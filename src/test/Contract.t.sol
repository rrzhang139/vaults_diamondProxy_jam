// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Diamond.sol";
import "../facets/DiamondCutFacet.sol";
import "../facets/DiamondLoupeFacet.sol";
import "../facets/OwnershipFacet.sol";
import "../libraries/LibDiamond.sol";
import "../upgradeInitializers/DiamondInit.sol";
import "../interfaces/IDiamondCut.sol";
import "../interfaces/IDiamondLoupe.sol";

import "forge-std/Vm.sol";
import "forge-std/console.sol";

import "forge-std/Test.sol";

contract ContractTest is DSTest, Test {
    // using stdStorage for StdStorage;

    // Vm private vm = Vm(HEVM_ADDRESS);
    Diamond private diamond;
    DiamondCutFacet private diamondCut;
    DiamondLoupeFacet private diamondLoupeFacet;
    DiamondInit private diamondInit;
    OwnershipFacet private ownershipFacet;

    // StdStorage private stdstore;

    function setUp() public {
        //deploy diamond cut
        diamondCut = new DiamondCutFacet();
        diamond = new Diamond(address(this), address(diamondCut));
        diamondLoupeFacet = new DiamondLoupeFacet();
        diamondInit = new DiamondInit();
        ownershipFacet = new OwnershipFacet();
        // console.log(diamondInit);

        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](1);
        // work with diamond loupe first
        bytes4[] memory functionSelectorsDiamondLoupeFacet = new bytes4[](5);
        functionSelectorsDiamondLoupeFacet[0] = diamondLoupeFacet
            .facets
            .selector;
        functionSelectorsDiamondLoupeFacet[1] = diamondLoupeFacet
            .facetFunctionSelectors
            .selector;
        functionSelectorsDiamondLoupeFacet[2] = diamondLoupeFacet
            .facetAddresses
            .selector;
        functionSelectorsDiamondLoupeFacet[3] = diamondLoupeFacet
            .facetAddress
            .selector;
        functionSelectorsDiamondLoupeFacet[4] = diamondLoupeFacet
            .supportsInterface
            .selector;
        cut[0] = IDiamondCut.FacetCut({
            facetAddress: address(diamondLoupeFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: functionSelectorsDiamondLoupeFacet
        });
        IDiamondCut(address(diamond)).diamondCut(
            cut,
            address(diamondInit),
            abi.encodeWithSelector(bytes4(0xe1c7392a)) //DiamondInit.init selector
        );
    }

    function testSetup() public {
        address[] memory addresses = IDiamondLoupe(address(diamond))
            .facetAddresses();
        assertEq(addresses.length, 2);
        bytes4[] memory facet1Selectors = IDiamondLoupe(address(diamond))
            .facetFunctionSelectors(addresses[0]);
        assertGt(facet1Selectors.length, 0);
        bytes4[] memory facet2Selectors = IDiamondLoupe(address(diamond))
            .facetFunctionSelectors(addresses[1]);
        assertGt(facet2Selectors.length, 0);
        assertEq(
            IDiamondLoupe(address(diamond)).facetAddress(bytes4(0x1f931c1c)),
            addresses[0]
        );
        assertEq(
            IDiamondLoupe(address(diamond)).facetAddress(bytes4(0xcdffacc6)),
            addresses[1]
        );
        assertEq(
            IDiamondLoupe(address(diamond)).facetAddress(bytes4(0x01ffc9a7)),
            addresses[1]
        );
    }
}
