# Interactuando con los métodos del estándar ERC20

## Introducción

El estándar ERC20 es ampliamente utilizado en la plataforma Ethereum para la creación de tokens fungibles, lo que significa que cada unidad del token es intercambiable por otra unidad del mismo token. Los tokens ERC20 se utilizan comúnmente en aplicaciones descentralizadas (DApps) y en la creación de criptomonedas.

En este laboratorio, aprenderemos cómo interactuar con los métodos del estándar ERC20 en Solidity utilizando Remix.

## Objetivos

- Crear un activo digital basado en el estándar ERC20
- Comprender los métodos de un token ERC20
- Interactuar con los métodos de un token ERC20

## Desarrollo

1. Abre [Remix](https://remix.ethereum.org/) en tu navegador web

2. Crea un nuevo archivo de contrato llamado `TokenERC20.sol`

3. Copia y pega el código siguiente en el archivo `TokenERC20.sol` Reemplaza el nombre del token `MiToken` por tu nombre. Crea un símbolo para tu token reemplazando `MIT`.

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity 0.8.18;
   
   import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
   
   contract TokenERC20 is ERC20 {
       constructor() ERC20("MiToken", "MIT") {
           //Acuña 1000 MIT tokens a msg.sender (Propietario)
          _mint(msg.sender, 1000 * 10 ** decimals());
       }
   }
   ```

4. Haz clic en el ícono `Solidity Compiler` en la barra de la izquierda y compila el archivo con `Compile TokenERC20.sol`. No debería mostrar ningún error.

   ![image](https://github.com/zulyta/BootcampBB/assets/32932810/6be6a30f-064f-4438-9877-f715d51b0abc)

5. Abre tu billetera Metamask y verifica que estás conectado a la red `Mumbai`. Nota la `M` (de `Mumbai`) en la esquina superior izquierda de la billetera

   ![conectM](https://github.com/zulyta/BootcampBB/assets/32932810/f5461d8a-234d-422f-83f4-c313c1f3182b)

6. En Remix, haz en el clic en el ícono de la izquierda llamado `Deploy & run transactions`. En la sección de `ENVIRONMENT`, abre la sección desplegable y selecciona la opción `Injected Provider - Metamask`.

   ![image](https://github.com/zulyta/BootcampBB/assets/32932810/258735e3-7369-4c85-b258-7bf6abaf80b1)

7. Haz clic en el botón `Deploy` para publicar el contrato a la red  `Mumbai`. La ventana de `Metamask` se abrirá.

   ![image](https://github.com/zulyta/BootcampBB/assets/32932810/720be5c4-5ce0-4d03-a6b8-7012a80e44ef)

8. Al abrirse, dar clic en `Confirmar`. Nota que el `address` que está publicando el contrato es la siguiente: `0x07436E9e77e589f768a29510766b30aD448C37ED`. A esta `address` le vamos a llamar `Owner` o `Propietario`. En tu Remix aparecerá otra `address` que será la misma de tu `Metamask`.

   ![image](https://github.com/zulyta/BootcampBB/assets/32932810/fd0ec8ee-0ba8-4bbe-b0fd-b0bd66ef2e36)

9. Al confirmarse, la transacción se va a procesar y de ser exitosa se mostrará el check verde en Remix. Puede tardar unos cuantos segundos. Verifica que todo fue bien revisando el check.

   ![image](https://github.com/zulyta/BootcampBB/assets/32932810/f9a8b795-188c-45ef-90f6-9a4cf37af5bf)

   El código que acabas de copiar, compilar y desplegar representa un contrato inteligente que crea y asigna 1000 MIT con 18 ceros, lo que equivale a 1000000000000000000000 tokens al  `Propietario`. Más adelante veremos cómo verificar esto preguntándole al contrato.

10. El método `_mint` permite la creación y asignación de tokens a una billetera o address específica. En este caso, `msg.sender` se refiere al address de la persona que está
    desplegando el contrato, es decir, el `Propietario`.

    ![mint](https://github.com/zulyta/BootcampBB/assets/32932810/1703d713-8eaa-4700-8cf5-0d0a51f1ff5a)

    El método `mint` es esencial en la creación de tokens ERC20, ya que define la cantidad de tokens en circulación al inicio y asigna estos tokens a la dirección del `Propietario`. A partir de este punto, los tokens pueden transferirse a otras direcciones y utilizarse en diversas transacciones dentro de la
    red Ethereum.

11. Además del método `mint` , en un contrato ERC20, a menudo se incluye el método `burn`. Este método permite que el `Propietario` del contrato destruya (queme o elimine) una cierta cantidad de tokens, reduciendo así la oferta total de tokens. Aquí está cómo funciona el método `burn`:
    
    - Desde la cuenta del `Propietario`, se llama al método `burn` del contrato ERC20. El `Propietario` debe especificar la cantidad de tokens que desea quemar.
    
    - Después de confirmar la transacción en tu billetera, se ejecutará la función `burn`, y la cantidad especificada de tokens se eliminará permanentemente del sistema.
    
    La quema de tokens es una técnica para reducir la oferta total de tokens, lo que puede ayudar a controlar la inflación o eliminar tokens no utilizados. Una vez que los tokens se queman, no se pueden recuperar.

12. En la columna izquierda de Remix, podrás visualizar los métodos del estándar ERC20. Tienes métodos en color `amarillo` (escritura) y otros en `azul` (lectura).

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/842ab47a-40fa-4a5a-9a28-f62f45b78b15)

13. Vamos a crear dos billeteras adicionales en `Metamask` que se llamarán `Destinatario` y `Gastador`. Para crear estas cuentas sigue este procedimiento en `Metamask`:

    1. Dirígete a la extensión de tu billetera `Metamask`. Le das clic a `Propietario` y luego a `+ Add account`.

       ![cuentas](https://github.com/zulyta/BootcampBB/assets/32932810/265ecdf4-c79d-4c24-abb6-7430145e6150)

    2. Ingresas el nombre de la cuenta a crear (`Destinatario` o `Gastador`) y luego clic en `Crear`.

       ![creawal](https://github.com/zulyta/BootcampBB/assets/32932810/540c8721-f372-40fa-9f2e-c0bc284424b8)

    3. Como resultado de estos pasos, tu Metamask debería contener 3 billeteras (`Propietario`, `Destinatario` y `Gastador`), como se muestra en la imagen.

       ![wallets](https://github.com/zulyta/BootcampBB/assets/32932810/c588b392-e188-44c7-82da-cff56ac5188d)

14. `name()`: Para obtener el nombre del token, haz clic en el botón azul que dice `name`. El resultado será el nombre que asignamos en el contrato que es `MiToken`

    ```solidity
    constructor() ERC20("MiToken", "MIT")...
    ```

15. `symbo()`: Para obtener el símbolo del token, haga clic en el botón azul que dice `symbol`. El resultado será el símbolo que asignamos al token en el contrato inteligente: `MIT`.

16. `decimals()`: Para obtener la cantidad de decimales del token, haga clic en el botón azul que dice `decimals`. El resultado será 18, que representa la unidad mínima divisible del token.

17. `totalSupply()`: Consulta el método `totalSupply`. Por ahora el valor es de 1000000000000000000000. Este número representa los 1000 tokens (con 18 decimales) que fueron acuñados al `Propietario`.

    El valor de `totalSupply` cambia con el tiempo y representa la cantidad de tokens acuñados hasta el momento. Los métodos `mint` y `burn` alteran el valor de `totalSupply`.

18. `balanceOf()`: Consulta los balances del `Propietario` y el `Destinatario` utilizando el método `balanceOf`. Éste retorna el saldo total de tokens asignados o acuñados a una cuenta en específico, el argumento para este método es cualquier billetera.

    Balance de `Propietario`
    
    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/e67ff51d-1d57-4bc6-9109-020d665ec93f)

    Balance de `Destinatario`

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/ee0bd001-2a4b-4ab6-9414-e6a3414ac661)

    El resultado de estas consultas debería ser:

    |                | balanceOf(address) (MIT tokens) |
    | -------------- | ------------------------------- |
    | `Propietario`  | 1000000000000000000000          |
    | `Destinatario` | 0                               |

20. `transfer()`: Realiza una transferencia de tokens de una billetera a otra usando el método `transfer`. Vamos a transferir 100000000000000000000 tokens (100 tokens con 18 decimales) del `Propietario` al `Destinatario`.

    ![gtransfer](https://github.com/zulyta/BootcampBB/assets/32932810/c3f8f6b6-6771-46ae-8caa-7ef64c4cb1f6)

    Para utilizar este método, desde la cuenta del `Propietario`, selecciona el método `transfer`, ingresa el address de la cuenta `Destinatario` y la cantidad de 100000000000000000000 MIT tokens. Luego, confirma la transacción.

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/a7d2cdec-d58e-4721-970b-6a122ebbd5a6)

    El `Propietario` cuenta con un saldo inicial de 1000000000000000000000 MIT tokens (1000 tokens con 18 decimales) y el `Destinatario` tiene un saldo inicial de 0 MIT tokens. Luego de ejecutar `transfer`, se descontaron 100000000000000000000 MIT tokens de la billetera del `Propietario` y se incrementaron 100000000000000000000 MIT tokens en la billetera del `Destinatario`.

20. Vuelve a consultar los balances del `Propietario` y el `Destinatario` del paso 13. Observarás que el balance de la cuenta del `Propietario` disminuyó en 100000000000000000000 y el de la cuenta del `Destinatario` se incrementó en 100000000000000000000, que es el monto de tokens transferidos.

    Balance de `Propietario`

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/e622783e-b7e6-4b8c-bdb4-5d0758af6136)

    Balance de `Destinatario`

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/a4274bc7-0aee-4f63-af75-c34653af6b1a)

    El resultado de esta consulta debería ser:

    |                | balanceOf(address) (MIT tokens)                         |
    | -------------- | ------------------------------------------------------- |
    | `Propietario`  | 1000 \* 10\*\*18 - 100 * 10**18 = 900000000000000000000 |
    | `Destinatario` | 100000000000000000000                                   |


21. `approve()`: Según el estándar ERC20, el método `approve` permite que el `Propietario` pueda autorizar a un  `Gastador` para que maneje un monto de tokens en específico en representación del `Propietario`.

    Para utilizar el método `approve`, desde la cuenta del `Propietario`, selecciona la función `approve`. Luego, ingresa el address de la cuenta del `Gastador` y la cantidad de tokens que deseas autorizar. En mi caso, estoy otorgando permiso para el manejo de 200000000000000000000 MIT tokens al `Gastador`. Luego, confirma y aprueba la transacción.

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/baa4307c-d6cb-4345-867a-a0c05c3f2007)

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/ec2ade49-8180-4fe3-810e-201582787080)

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/5dbd4935-abbc-4d78-963c-f591a08835b7)


    Como puedes observar en el gráfico del método `approve`, el `Propietario` autoriza al `Gastador` para manejar 200000000000000000000 MIT tokens en su representación, pero no los transfiere. En su lugar, cuando el `Gastador` decida realizar alguna operación con el monto autorizado, se deducirá del saldo en la billetera del
    `Propietario`, mientras que la billetera del `Gastador` continuará manteniendo su saldo inicial, que es cero.

22. `allowance()`: Para indagar el permiso que el `Propietario` le dio al `Gastador`, hacemos uso del método `allowance`. Selecciona el método `allowance`, ingresa el `Propietario` y el `Gastador`.

    En el estándar ERC20 el `owner` hace referencia al dueño de los tokens, en este caso el `Propietario`, mientras que `spender` representa el address quien recibió el permiso para manejar los tokens, es decir, el `Gastador`.

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/a571465f-8b15-41ed-8bae-7e46376f22ce)

23. Haremos uso del permiso (allowance) que el `Propietario` brindó al `Gastador` utilizando el método `tranferFrom`. 

    ![image-20230908154727546](https://github.com/zulyta/BootcampBB/assets/3300958/e269c83f-7c1d-4b2d-bbb9-1aef3e4eec50)

    El `Gastador` empieza con un permiso a manejar de 200000000000000000000 MIT tokens. Se planea transferir 100000000000000000000 MIT tokens. Esta transferencia de tokens al `Destinatario` lo realiza el `Gastador` en nombre del `Propietario`. La deducción se efectúa desde la billetera del `Propietario`. El `Gastador` disminuye su permiso (allowance).

    Hacemos clic en la extensión `Metamask` y seleccionamos el address del `Gastador`, ello se reflejará automáticamente en Remix.

    Selecciona el método `tranferFrom`, e ingresa los siguientes argumentos:

    * `from`: Address del `Propietario``
    * `to`: Address del `Destinatario`
    * `amount`: 100000000000000000000

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/73763675-02de-45cf-9041-8bd2bc039536)

24. Verifica el saldo total de la cuenta del `Propietario`  y el `Destinatario` repitiendo el punto 13. Observarás que disminuyó en 100000000000000000000 MIT tokens, ya que el `Propietario` autorizó 200000000000000000000 MIT tokens al `Gastador`, pero éste solo gastó 100000000000000000000 MIT tokens al transferirlo al `Destinatario`. Esta cantidad se descontó de la cuenta del `Propietario`.

     Balance de `Propietario`

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/76918dd4-6c90-4690-9579-aa41d0c9153b)

     Balance de `Destinatario`

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/99c7aa24-e820-4d47-a0a3-b413c75f0ce2)

    El de saldo final de las 3 cuentas es el siguiente:

    |                | balanceOf(address) (MIT tokens) |
    | -------------- | ------------------------------- |
    | `Propietario`  | 800000000000000000000           |
    | `Destinatario` | 200000000000000000000           |
    |                | 0                               |

25. Utiliza el método `increaseAllowance` para aumentar la autorización del `Gastador` para gastar más tokens en nombre del `Propietario`. Deberás proporcionar dos argumentos:

    - `spender`: La dirección del `Gastador` al que deseas aumentar la autorización.
    - `addedValue`: La cantidad de tokens adicionales que deseas autorizar al `Gastador` a gastar en mi caso incrementaré en el permiso en 200000000000000000000.

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/56a476d4-a1f4-4ed7-b1f4-36fce3e2c859)


    El de saldo total de las 3 cuentas después de aplicar el método es el siguiente:

    |                | balanceOf(address) (MIT tokens) | allowance de Propietario |
    | -------------- | ------------------------------- | ------------------------ |
    | `Propietario`  | 800000000000000000000           | 0                        |
    | `Destinatario` | 200000000000000000000           | 0                        |
    | `Gastador`     | 0                               | 300000000000000000000    |


26. Para disminuir la autorización del `Gastador` para gastar menos tokens en nombre del `Propietario`, llama al método `decreaseAllowance`. Deberás proporcionar dos argumentos:

      - `spender`: La dirección del `Gastador` cuya autorización deseas reducir.
      - `subtractedValue`: La cantidad de tokens que deseas restar de la autorización existente. En mi caso, disminuiré el permiso en 50000000000000000000.

    ![image](https://github.com/zulyta/BootcampBB/assets/32932810/a9388b55-890c-4b3d-9c43-121e3d974034)


    Esto permite un mayor control sobre los límites de gasto del `Gastador` sin necesidad de revocar por completo la autorización.

    El de saldo total de las 3 cuentas después de aplicar el método es el siguiente:

    |                | balanceOf(address) (MIT tokens) | allowance de Propietario |
    | -------------- | ------------------------------- | ------------------------ |
    | `Propietario`  | 800000000000000000000           | 0                        |
    | `Destinatario` | 200000000000000000000           | 0                        |
    | Gastador       | 0                               | 250000000000000000000    |

27. Responde a esta pregunta:
    1. ¿Qué es lo que más te llamó la atención de este estándar?
    2. ¿Alguna funcionalidad que crees que está faltando? ¿Qué quitarías o añadirías?

## Conclusión

¡Felicidades! Has completado exitosamente este laboratorio, explorando los conceptos clave del estándar ERC20 y sus métodos en Solidity. Ahora tienes un conocimiento a alto nivel de los métodos de este estándar.
