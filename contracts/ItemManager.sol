 // SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable {

    enum SupplyChainSteps{Created, Paid, Delivered}

    struct S_Item {
        Item _item;
        ItemManager.SupplyChainSteps _step;
        string _identifier;
        uint _itemPrice;
    }
    mapping(uint => S_Item) public items;
    uint itemIndex;

    event SupplyChainStep(uint _itemIndex, uint _step, address _itemAddress);

    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner {
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._step = SupplyChainSteps.Created;
        items[itemIndex]._identifier = _identifier;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._step), address(item));
        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable {
        require(items[_itemIndex]._itemPrice <= msg.value, "Not fully paid");
        require(items[_itemIndex]._step == SupplyChainSteps.Created, "Item is further in the supply chain");
        items[_itemIndex]._step = SupplyChainSteps.Paid;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._step), address(items[_itemIndex]._item));
    }

    function triggerDelivery(uint _itemIndex) public onlyOwner {
        require(items[_itemIndex]._step == SupplyChainSteps.Paid, "Item is further in the supply chain");
        items[_itemIndex]._step = SupplyChainSteps.Delivered;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._step), address(items[_itemIndex]._item));
    }
}