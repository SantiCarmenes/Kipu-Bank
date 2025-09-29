# 🌐 KipuBank

## 🔹 Descripción

**KipuBank** es un contrato inteligente que permite a los usuarios **depositar y retirar ETH**.

---

## 🔹 Caracteristicas de funcionabilidad y seguridad

* Depositar ETH en una **bóveda personal**.
* Retiros limitados por un **límite máximo por transacción** (`withdrawLimit`).
* Límite global de depósitos (`bankCap`).
* Emisión de eventos para depósitos y retiros.
* Contadores globales de **total de depósitos** y **total de retiros**.
* Patrón **checks-effects-interactions**
* Transferencias de ETH seguras con `_safeTransfer`
* Errores personalizados
* Variables y funciones documentadas con NatSpec

---

## 🔹 Instrucciones de despliegue

**Constructor en Remix:**
Ejemplo utilizado en el despliegue del contrato en la TestNet Sepolia

uint128 bankCap = 1000000000000000000000;
(10000 ETH)

uint128 withdrawLimit = 5000000000000000000;
(5 ETH)

1. Seleccionar **Sepolia** en Remix → Injected Web3 (MetaMask).
2. Ingresar los valores en el constructor.
3. Presionar **Deploy**.

---

## 🔹 Cómo interactuar con el contrato

### 1️⃣ Depositar ETH

* Función: `deposit()`
* Valor: cantidad de ETH en wei
* Resultado:

  * Balance del usuario incrementa
  * `totalDeposits` incrementa
  * Evento `Deposited` emitido ✅

### 2️⃣ Retirar ETH

* Función: `withdraw(uint128 amount)`
* Verifica saldo suficiente y límite por transacción
* Resultado:

  * Balance del usuario decrementa
  * `totalWithdrawals` incrementa
  * Evento `Withdrawn` emitido ✅

### 3️⃣ Consultar balances

 getMyBalance();      // Saldo del usuario
 getTotalBalance();   // Saldo total del banco
 totalDeposits;       // Total de depósitos
 totalWithdrawals;    // Total de retiros

### 4️⃣ Errores personalizados

| Error                | Descripción                                           |
| -------------------- | ----------------------------------------------------- |
| ExceedsBankCap       | Se intenta depositar más de lo permitido por el banco |
| ExceedsWithdrawLimit | Se intenta retirar más que el límite por transacción  |
| InsufficientBalance  | No hay suficiente saldo para retirar                  |
| TransferFailed       | Falló la transferencia de ETH al usuario              |

---
