// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
REPETIBLE CON LÍMITE, PREMIO POR REFERIDO

* El usuario puede participar en el airdrop una vez por día hasta un límite de 10 veces
* Si un usuario participa del airdrop a raíz de haber sido referido, el que refirió gana 3 días adicionales para poder participar
* El contrato Airdrop mantiene los tokens para repartir (no llama al `mint` )
* El contrato Airdrop tiene que verificar que el `totalSupply`  del token no sobrepase el millón
* El método `participateInAirdrop` le permite participar por un número random de tokens de 1000 - 5000 tokens
*/

interface IMiPrimerTKN {
    function transfer(address to, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
    
}

contract AirdropTwo is Pausable, AccessControl {
    // instanciamos el token en el contrato
    IMiPrimerTKN miPrimerToken;

    struct Usuario {
        uint256 balance;
        uint8 maxAttempts;
        uint256 limiteParticipaciones;
        uint256 nextAttempt;
        uint8 attempts;
    }


    mapping(address => Usuario) public participantes;

    constructor(address _tokenAddress) {
        miPrimerToken = IMiPrimerTKN(_tokenAddress);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        
    }


    function participateInAirdrop() public { //mandar todos los token a este contrato
        require(miPrimerToken.balanceOf(address(this)) > 0, "El contrato Airdrop no tiene tokens suficientes");
        require(block.timestamp > participantes[msg.sender].nextAttempt || participantes[msg.sender].nextAttempt == 0,  "Ya participaste en el ultimo dia"); 
        require(participantes[msg.sender].attempts < 10,  "Llegaste limite de participaciones"); 
        miPrimerToken.transfer(address(this), _getRadomNumber10005000());
        participantes[msg.sender].nextAttempt = block.timestamp + 1 days;
        if(participantes[msg.sender].attempts == 0){participantes[msg.sender].limiteParticipaciones = 10;}
        participantes[msg.sender].limiteParticipaciones--;
        participantes[msg.sender].attempts++;
    }

    function participateInAirdrop(address _elQueRefirio) public {
        require(msg.sender != _elQueRefirio, "No puede autoreferirse");
        if(participantes[_elQueRefirio].attempts == 0){participantes[_elQueRefirio].limiteParticipaciones = 10;}
        participantes[_elQueRefirio].nextAttempt += 3 days;
        participantes[_elQueRefirio].limiteParticipaciones += 3;

    }

    ///////////////////////////////////////////////////////////////
    ////                     HELPER FUNCTIONS                  ////
    ///////////////////////////////////////////////////////////////

    function _getRadomNumber10005000() internal view returns (uint256) {
        return
            (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) %
                4000) +
            1000 +
            1;
    }

    function setTokenAddress(address _tokenAddress) external {
        miPrimerToken = IMiPrimerTKN(_tokenAddress);
    }

    function transferTokensFromSmartContract()
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        miPrimerToken.transfer(
            msg.sender,
            miPrimerToken.balanceOf(address(this))
        );
    }
}
