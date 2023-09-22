// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/** CUASI SUBASTA INGLESA
 *
 * Descripción:
 * Tienen la tarea de crear un contrato inteligente que permita crear subastas Inglesas (English auction).
 * Se paga 1 Ether para crear una subasta y se debe especificar su hora de inicio y finalización.
 * Los ofertantes envian sus ofertas a la subasta que ellos deseen durante el tiempo que la subasta esté abierta.
 * Cada subasta tiene un ID único que permite a los ofertantes identificar la subasta a la que desean ofertar.
 * Los ofertantes para poder proponer su oferta envían Ether al contrato (llamando al método 'proponerOferta' o enviando directamente).
 * Las ofertas deben ser mayores a la oferta más alta actual para una subasta en particular.
 * Si se realiza una oferta dentro de los 5 minutos finales de la subasta, el tiempo de finalización se extiende en 5 minutos
 * Una vez que el tiempo de la subasta se cumple, cualquier puede llamar al método 'finalizarSubasta' para finalizar la subasta.
 * Cuando finaliza la subasta, el ganador recupera su oferta y se lleva el 1 Ether depositado por el creador.
 * Cuando finaliza la subasta se emite un evento con el ganador (address)
 * Las personas que no ganaron la subasta pueden recuperar su oferta después de que finalice la subasta
 *
 * ¿Qué es una subasta Inglesa?
 * En una subasta inglesa el precio comienza bajo y los postores pujan el precio haciendo ofertas.
 * Cuando se cierra la subasta, se emite un evento con el mejor postor.
 *
 * Métodos a implementar:
 * - El método 'creaSubasta(uint256 _startTime, uint256 _endTime)':
 *      * Crea un ID único del typo bytes32 para la subasta y lo guarda en la lista de subastas activas
 *      * Permite a cualquier usuario crear una subasta pagando 1 Ether
 *          - Error en caso el usuario no envíe 1 Ether: CantidadIncorrectaEth();
 *      * Verifica que el tiempo de finalización sea mayor al tiempo de inicio
 *          - Error en caso el tiempo de finalización sea mayo al tiempo de inicio: TiempoInvalido();
 *      * Disparar un evento llamado 'SubastaCreada' con el ID de la subasta y el creador de la subasta (address)
 *
 * - El método 'proponerOferta(bytes32 _auctionId)':
 *      * Verifica que ese ID de subasta (_auctionId) exista
 *          - Error si el ID de subasta no existe: SubastaInexistente();
 *      * Usando el ID de una subasta (_auctionId), el ofertante propone una oferta y envía Ether al contrato
 *          - Error si la oferta no es mayor a la oferta más alta actual: OfertaInvalida();
 *      * Solo es llamado durante el tiempo de la subasta (entre el inicio y el final)
 *          - Error si la subasta no está en progreso: FueraDeTiempo();
 *      * Emite el evento 'OfertaPropuesta' con el postor y el monto de la oferta
 *      * Guarda la cantidad de Ether enviado por el postor para luego poder recuperar su oferta en caso no gane la subasta
 *      * Añade 5 minutos al tiempo de finalización de la subasta si la oferta se realizó dentro de los últimos 5 minutos
 *      Nota: Cuando se hace una oferta, incluye el Ether enviado anteriormente por el ofertante
 *
 * - El método 'finalizarSubasta(bytes32 _auctionId)':
 *      * Verifica que ese ID de subasta (_auctionId) exista
 *          - Error si el ID de subasta no existe: SubastaInexistente();
 *      * Es llamado luego del tiempo de finalización de la subasta usando su ID (_auctionId)
 *          - Error si la subasta aún no termina: SubastaEnMarcha();
 *      * Elimina el ID de la subasta (_auctionId) de la lista de subastas activas
 *      * Emite el evento 'SubastaFinalizada' con el ganador de la subasta y el monto de la oferta
 *      * Añade 1 Ether al balance del ganador de la subasta para que éste lo puedo retirar después
 *
 * - El método 'recuperarOferta(bytes32 _auctionId)':
 *      * Permite a los usuarios recuperar su oferta (tanto si ganaron como si perdieron la subasta)
 *      * Verifica que la subasta haya finalizado
 *      * El smart contract le envía el balance de Ether que tiene a favor del ofertante
 *
 * - El método 'verSubastasActivas() returns(bytes32[])':
 *      * Devuelve la lista de subastas activas en un array
 *
 * Para correr el test de este contrato:
 * $ npx hardhat test test/EjercicioIntegrador_4.ts
 */

contract Desafio_4 {

    bytes32[] arrayAuctions;

    struct Auction {
        bool active;
        uint256 startTime;
        uint256 endTime;
        uint256 createdAt;
        uint256 highestBid;
        address highestBidder;
        address[] offersAccounts;
        mapping(address => uint256) offers;
    }
        
    mapping(bytes32 auction => Auction subasta) public auctions;
    //mapping(bytes32 => mapping(address => uint256)) offers

    event SubastaCreada(bytes32 indexed _auctionId, address indexed _creator);
    event OfertaPropuesta(address indexed _bidder, uint256 _bid);
    event SubastaFinalizada(address indexed _winner, uint256 _bid);

    error CantidadIncorrectaEth();
    error TiempoInvalido();
    error SubastaInexistente();
    error FueraDeTiempo();
    error OfertaInvalida();
    error SubastaEnMarcha();

    function creaSubasta(uint256 _startTime, uint256 _endTime) public payable {
        if(msg.value < 1 ether) revert CantidadIncorrectaEth();
        if(_endTime < _startTime) revert TiempoInvalido();
        bytes32 _auctionId = _createId(_startTime, _endTime);
        arrayAuctions.push(_auctionId);
        Auction storage nuevaSubasta = auctions[_auctionId];
        nuevaSubasta.active = true;
        nuevaSubasta.startTime = _startTime;
        nuevaSubasta.endTime = _endTime;
        nuevaSubasta.createdAt = block.timestamp;
        //nuevaSubasta.ofertaActual = 0;

        emit SubastaCreada(_auctionId, msg.sender);
    }

     function proponerOferta(bytes32 _auctionId) public payable {
        if (!auctions[_auctionId].active) revert SubastaInexistente();
        if (auctions[_auctionId].highestBid > msg.value) revert OfertaInvalida();
        if (block.timestamp > auctions[_auctionId].endTime) revert FueraDeTiempo();
        
        auctions[_auctionId].highestBid = msg.value;
        auctions[_auctionId].highestBidder = msg.sender;
        auctions[_auctionId].offersAccounts.push(msg.sender);
        auctions[_auctionId].offers[msg.sender] += msg.value;
        
        if ((auctions[_auctionId].endTime - block.timestamp) < 5 minutes){
            auctions[_auctionId].endTime += 5 minutes;
        }

        emit OfertaPropuesta(msg.sender, auctions[_auctionId].offers[msg.sender]);
    } 
    

    function finalizarSubasta(bytes32 _auctionId) public {
        if (!auctions[_auctionId].active) revert SubastaInexistente();
        if (block.timestamp < auctions[_auctionId].endTime) revert SubastaEnMarcha();
        require(auctions[_auctionId].active, "La Subasta no se puede volver a finalizar");
        if(auctions[_auctionId].active){
            auctions[_auctionId].active = false;
            auctions[_auctionId].offers[auctions[_auctionId].highestBidder] += 1 ether;
        }

        emit SubastaFinalizada(auctions[_auctionId].highestBidder, auctions[_auctionId].highestBid);
    }

    function recuperarOferta(bytes32 _auctionId) public {
        if (block.timestamp < auctions[_auctionId].endTime) revert SubastaEnMarcha();
            uint256 amountToTransfer = auctions[_auctionId].offers[msg.sender];
            payable(msg.sender).transfer(amountToTransfer);
    }

    function verSubastasActivas() public view returns (bytes32[] memory) {
        bytes32[] memory arrayActiveAuctions = new bytes32[](arrayAuctions.length);
        for (uint i = 0 ; i < arrayAuctions.length; i++) {
            if(auctions[arrayAuctions[i]].active){
                arrayActiveAuctions[i] = arrayAuctions[i];
            }
        }
        return arrayActiveAuctions;
    }

    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////   INTERNAL METHODS  ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////

    function _createId(
        uint256 _startTime,
        uint256 _endTime
    ) internal view returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    _startTime,
                    _endTime,
                    msg.sender,
                    block.timestamp
                )
            );
    }
}
