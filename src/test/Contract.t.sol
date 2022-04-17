// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Diamond.sol";
import "../facets/DiamondCutFacet.sol";
import "../facets/DiamondLoupeFacet.sol";
import "../libraries/LibDiamond.sol";

import "forge-std/Vm.sol";
import "forge-std/console.sol";

import "forge-std/Test.sol";

contract ContractTest is DSTest, Test {
    // using stdStorage for StdStorage;

    // Vm private vm = Vm(HEVM_ADDRESS);
    Diamond private diamond;
    DiamondCutFacet private diamondCut;
    DiamondLoupeFacet private diamondLoupeFacet;

    // StdStorage private stdstore;

    function setUp() public {
        //deploy diamond cut
        diamondCut = new DiamondCutFacet();
        diamond = new Diamond(address(this), address(diamondCut));
        diamondLoupeFacet = new DiamondLoupeFacet();
    }

    function testFailSetup() public {
        vm.prank(address(diamond));
        address diamondAddress = address(diamond);
        // vm.mockCall(
        //     diamondAddress,
        //     abi.encodePacked(diamondCut.diamondCut.selector),
        //     abi.encodePacked(diamondCut.diamondCut.selector)
        // );
        // assembly {
        //     let success := call(
        //         gas(),
        //         diamondAddress,
        //         0,
        //         0,
        //         calldatasize(),
        //         0,
        //         returndatasize()
        //     )
        // }
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        console.log(ds.contractOwner);
        // // console.log("here");
        // // console.log(string(diamondCut.diamondCut.selector));
        // bytes4[] memory selectors = diamondLoupeFacet.facetFunctionSelectors(
        //     address(diamondCut)
        // );
        // console.logBytes4(diamondCut.diamondCut.selector);
        // address facet = diamondLoupeFacet.facetAddress(bytes4(0x1f931c1c));
        // // address facet = ds
        // //     .facetAddressAndSelectorPosition[diamondCut.diamondCut.selector]
        // //     .facetAddress;
        // console.log(facet);
        // assertEq(facet, address(0));
    }
}
