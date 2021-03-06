// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "./token.sol";

contract TokenVesting is Ownable {

    using SafeMath for uint256;

    IERC20 private token;

    struct vestingScheme {
        address beneficiary;
        uint256 startTime;
        uint256 duration;
        uint256 releaseSchedule;
        uint256 amount;
        uint256 tokensReleased;
        bool isValid;
    }

    uint256 private schemeCountLimit;
    uint256 private schemeCount;
    uint256 private schemeId;
    uint256 private beneficiarySchemeCountLimit;
    mapping (uint256 => vestingScheme) schemes;
    mapping (address => uint256[]) beneficiarySchemeIds;

    event VestingSchemeCreation (TokenVesting.vestingScheme);

    modifier notZeroAddress(address _token) {
        require (_token != address(0));
        _;
    }

    constructor (address _token) notZeroAddress (_token) {
        token = IERC20 (_token);
        schemeCountLimit = 10;
        beneficiarySchemeCountLimit = 1;
    }

    receive () external payable {}
    fallback () external payable {}

    function getVestingSchemeById (uint _schemeId) 
    external 
    view 
    returns (vestingScheme memory) {
        require (schemes[_schemeId].isValid == true, "TokenVesting: Vesting Scheme is either deleted or does not exist");
        return schemes[_schemeId];
    }

    function getBeneficiarySchemeCountLimit () external view returns (uint256) {
        return beneficiarySchemeCountLimit;
    }

    function getSchemeIdsByBeneficiary (address _beneficiary) external view returns (uint256[] memory) {
        return beneficiarySchemeIds[_beneficiary];
    }

    function getUnvestedAmountById (uint256 _schemeId) external view returns (uint256) {
        require (schemes[_schemeId].isValid == true, "TokenVesting: Vesting Scheme is either deleted or does not exist");
        vestingScheme memory scheme = schemes[_schemeId];
        uint256 unvestedAmount = scheme.amount.sub(scheme.tokensReleased);
        return unvestedAmount;
    }

    function getSchemeCountLimit () external view returns (uint256) {
        return schemeCountLimit;
    }

    function getSchemeCount () external view returns (uint256) {
        return schemeCount;
    } 

    function setSchemeCountLimit (uint _schemeCountLimit) public onlyOwner{
        schemeCountLimit = _schemeCountLimit;
    }

    function setBeneficiarySchemeCountLimit (uint _beneficiarySchemeCountLimit) public onlyOwner {
        beneficiarySchemeCountLimit = _beneficiarySchemeCountLimit;
    }

    function createVestingScheme (
        address _beneficiary,
        uint256 _startTime,
        uint256 _duration,
        uint256 _releaseSchedule,
        uint256 _amount
    ) external onlyOwner{
        require (_beneficiary != address(0), "TokenVesting: Cannot add zero address as beneficiary");
        require (_duration > 0, "TokenVesting: Vesting period must be greater than zero");
        require (_amount > 0, "TokenVesting: Vestable amount must be greater than 0");
        require (beneficiarySchemeIds[_beneficiary].length < beneficiarySchemeCountLimit, "TokenVesting: Scheme count for this beneficiary has reached limit.");

        vestingScheme memory scheme = vestingScheme (
         
         _beneficiary,
         _startTime,
         _duration,
         _releaseSchedule,
         _amount,
         0,
         true);

        schemeId = _calculateNewSchemeId(_beneficiary, schemeCount);
        beneficiarySchemeIds[scheme.beneficiary].push(schemeId);
        schemes[schemeId] = scheme;
        schemeCount.add(1);
        emit VestingSchemeCreation (scheme);
    }

    function releaseTokens (
        uint256 _schemeId,
        uint256 _amount
    ) 
    public {
        require (schemes[_schemeId].isValid == true);//merge
        require (_msgSender() == owner() || _msgSender() == schemes[_schemeId].beneficiary, "TokenVesting: Caller must be owner or beneficiary");
        
        vestingScheme memory scheme = schemes[_schemeId];

        uint256 vestedAmount = _calculateReleaseableAmount (scheme);
        require (_amount <= vestedAmount, "TokenVesting: Amount greater than current vested amount");

        scheme.tokensReleased = scheme.tokensReleased.add(_amount);
        token.transfer(scheme.beneficiary, _amount);
    }



    function _calculateReleaseableAmount (vestingScheme memory scheme) internal view returns (uint256) {
        uint256 now_ = _now();
        if (now_ < scheme.startTime.add(scheme.duration)){
            uint256 durationInMinutes = (scheme.duration * 1 days) / (scheme.releaseSchedule * 1 minutes);
            uint256 timeElapsed = now_.sub(scheme.startTime);
            uint256 vestingPeriodsElapsed = timeElapsed.div(scheme.releaseSchedule);
            uint256 releaseAmount = scheme.amount.mul(scheme.releaseSchedule).mul(vestingPeriodsElapsed).div(durationInMinutes);
            releaseAmount = releaseAmount.sub(scheme.tokensReleased);
            return releaseAmount;
        }
        else {
            return scheme.amount.sub(scheme.tokensReleased);
        }
            
    }

    function _calculateNewSchemeId (address _beneficiary, uint256 index) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_beneficiary, index))) % 1000000000;
    }

    function _now() internal virtual view returns (uint256) {
        return block.timestamp;
    }
}