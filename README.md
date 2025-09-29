# KipuBank

## Descripción

KipuBank es un contrato inteligente simple en Ethereum que permite a los usuarios **depositar y retirar ETH** siguiendo límites de seguridad.  
El contrato aplica:

- Límite total de ETH que puede almacenar (`bankCap`).  
- Límite máximo por retiro en una transacción (`withdrawLimit`).  
- Control de saldo por usuario y contadores de depósitos y retiros.  
- Manejo seguro de transferencias con errores personalizados.  

---

## Funcionalidades

- `deposit()`: Depositar ETH en tu cuenta personal dentro del banco.  
- `withdraw(uint128 amount)`: Retirar ETH, respetando límites y saldo disponible.  
- `getMyBalance()`: Consultar tu saldo personal.  
- `getTotalBalance()`: Consultar el saldo total del banco.  

Se emiten eventos `Deposited` y `Withdrawn` en cada operación exitosa.

---

## Límites

- `bankCap`: Límite total de ETH que puede almacenar el banco.  
- `withdrawLimit`: Límite máximo de retiro por transacción.  

Ambos se definen **al desplegar el contrato** y son inmutables.

---

## Errores personalizados

- `ExceedsBankCap(uint128 attempted, uint128 cap)` → al intentar depositar más del límite total.  
- `ExceedsWithdrawLimit(uint128 attempted, uint128 limit)` → al intentar retirar más que el límite.  
- `InsufficientBalance(uint128 requested, uint128 available)` → si no hay fondos suficientes.  
- `TransferFailed(address to, uint128 amount)` → si falla la transferencia de ETH.

---

## Instrucciones de despliegue

1. Abrir [Remix IDE](https://remix.ethereum.org/).  
2. Crear un nuevo archivo `KipuBank.sol` y pegar el código del contrato.  
3. Seleccionar **Solidity Compiler 0.8.20** y compilar.  
4. Ir a **Deploy & Run Transactions**:
   - Seleccionar la cuenta (MetaMask) y la red Sepolia.  
   - Definir los valores de `_bankCap` y `_withdrawLimit` (en wei, por ejemplo `1000000000000000000` = 1 ETH).  
   - Desplegar el contrato.  

5. Copiar la dirección del contrato desplegado para interactuar.

---

## Cómo interactuar

- **Depositar ETH:**  
  - Llamar a `deposit()` enviando ETH desde tu wallet.  

- **Retirar ETH:**  
  - Llamar a `withdraw(amount)` con la cantidad deseada (en uint128 wei).  

- **Consultar saldo propio:**  
  - `getMyBalance()`  

- **Consultar saldo total del banco:**  
  - `getTotalBalance()`

---

## Dirección del contrato desplegado

> A completar tras el despliegue en Sepolia.

---

## Notas de seguridad y buenas prácticas

- Todos los límites están definidos como **inmutables**.  
- Uso de errores personalizados para ahorrar gas y mejorar claridad.  
- Patrón **checks-effects-interactions** aplicado en retiros.  
- Transferencias de ETH manejadas con `_safeTransfer()` para evitar fallos silenciosos.  
- Contadores y saldos optimizados con `uint128` y `uint32` para minimizar gas.
