// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title KipuBank - Un banco simple con límites de depósito y retiro
/// @author Santiago Cármenes
/// @notice Este contrato permite a los usuarios depositar y retirar ETH con límites de seguridad
contract KipuBank {

    /// -----------------------------------------------------------------------------------------------
    ///                                   VARIABLES
    /// -----------------------------------------------------------------------------------------------

    /// @notice Límite total de ETH que se puede almacenar en el banco
    uint128 public immutable bankCap;

    /// @notice Límite de ETH que se puede retirar en una transacción
    uint128 public immutable withdrawLimit;

    /// @notice Número total de depósitos históricos
    uint32 public totalDeposits;

    /// @notice Número total de retiros históricos
    uint32 public totalWithdrawals;


    /// -----------------------------------------------------------------------------------------------
    ///                                    MAPPINGS
    /// -----------------------------------------------------------------------------------------------

    /// @notice Saldo de cada usuario
    mapping(address => uint128) private balances;

    /// -----------------------------------------------------------------------------------------------
    ///                                     EVENTOS
    /// -----------------------------------------------------------------------------------------------

    /// @notice Se emitirá al depositar ETH
    event Deposited(address indexed user, uint128 amount);

    /// @notice Se emitirá al retirar ETH
    event Withdrawn(address indexed user, uint128 amount);

    /// -----------------------------------------------------------------------------------------------
    ///                                     ERRORES
    /// -----------------------------------------------------------------------------------------------

    error ExceedsBankCap(uint128 attempted, uint128 cap);
    error ExceedsWithdrawLimit(uint128 attempted, uint128 limit);
    error InsufficientBalance(uint128 requested, uint128 available);
    error TransferFailed(address to, uint128 amount);

    /// -----------------------------------------------------------------------------------------------
    ///                                    CONSTRUCTOR
    /// -----------------------------------------------------------------------------------------------

    /// @param _bankCap Límite total de ETH que puede almacenar el banco
    /// @param _withdrawLimit Límite máximo por retiro en una transacción
    constructor(uint128 _bankCap, uint128 _withdrawLimit) {
        bankCap = _bankCap;
        withdrawLimit = _withdrawLimit;
    }

    /// -----------------------------------------------------------------------------------------------
    ///                                    MODIFICADORES
    /// -----------------------------------------------------------------------------------------------

    /// @notice Asegura que el depósito no supere el límite total del banco
    modifier withinCap(uint128 amount) {
        uint128 totalBalance = uint128(address(this).balance);
        if (totalBalance + amount > bankCap) {
            revert ExceedsBankCap(totalBalance + amount, bankCap);
        }
        _;
    }

    /// @notice Asegura que el retiro no supere el límite por transacción
    modifier withinWithdrawLimit(uint128 amount) {
        if (amount > withdrawLimit) {
            revert ExceedsWithdrawLimit(amount, withdrawLimit);
        }
        _;
    }

    /// @notice Asegura que el usuario tenga fondos suficientes
    modifier hasSufficientBalance(uint128 amount) {
        if (amount > balances[msg.sender]) {
            revert InsufficientBalance(amount, balances[msg.sender]);
        }
        _;
    }

    /// -----------------------------------------------------------------------------------------------
    ///                                     FUNCIONES PÚBLICAS
    /// -----------------------------------------------------------------------------------------------

    /// @notice Depositar ETH en el banco
    /// @dev Respeta el límite total del banco
    function deposit() external payable withinCap(uint128(msg.value)) {
        uint128 amount = uint128(msg.value);

        balances[msg.sender] += amount;
        _updateCounters(true);

        emit Deposited(msg.sender, amount);
    }

    /// @notice Retirar ETH del banco
    /// @param amount Cantidad de ETH a retirar
    /// @dev Respeta límites de retiro y saldo disponible, aplica patrón checks-effects-interactions
    function withdraw(uint128 amount) external withinWithdrawLimit(amount) hasSufficientBalance(amount) {
        balances[msg.sender] -= amount;
        _updateCounters(false);

        _safeTransfer(msg.sender, amount);

        emit Withdrawn(msg.sender, amount);
    }

    /// @notice Consultar el balance propio
    /// @return balance Cantidad de ETH disponible para el usuario
    function getMyBalance() external view returns (uint128 balance) {
        return balances[msg.sender];
    }

    /// @notice Consultar el balance total del banco
    /// @return totalBalance ETH total almacenado en el contrato
    function getTotalBalance() external view returns (uint256 totalBalance) {
        return address(this).balance;
    }

    /// -----------------------------------------------------------------------------------------------
    ///                                    FUNCIONES PRIVADAS
    /// -----------------------------------------------------------------------------------------------

    /// @notice Actualiza los contadores de depósitos y retiros
    /// @param isDeposit True si es depósito, false si es retiro
    function _updateCounters(bool isDeposit) private {
        if (isDeposit) {
            totalDeposits += 1;
        } else {
            totalWithdrawals += 1;
        }
    }

    /// @notice Transferencia de ETH segura
    /// @param to Dirección del destinatario
    /// @param amount Monto de ETH a enviar
    function _safeTransfer(address to, uint128 amount) private {
        (bool sent, ) = to.call{value: amount}("");
        if (!sent) {
            revert TransferFailed(to, amount);
        }
    }
}
