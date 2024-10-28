import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";

actor {
  type ItemId = Nat;
  
  type Item = {
    id : ItemId;
    description : Text;
    quantity : Nat;
    location : Text;
    lastUpdated : Time.Time;
  };

  var items = Buffer.Buffer<Item>(0);

  public func addItem(description : Text, quantity : Nat, location : Text) : async ItemId {
    let itemId = items.size();
    let newItem : Item = {
      id = itemId;
      description = description;
      quantity = quantity;
      location = location;
      lastUpdated = Time.now();
    };
    items.add(newItem);
    itemId;
  };

  public query func getItem(itemId : ItemId) : async ?Item {
    if (itemId < items.size()) {
      ?items.get(itemId);
    } else {
      null;
    };
  };

  public func updateQuantity(itemId : ItemId, newQuantity : Nat) : async Bool {
    if (itemId < items.size()) {
      let item = items.get(itemId);
      let updatedItem : Item = {
        id = item.id;
        description = item.description;
        quantity = newQuantity;
        location = item.location;
        lastUpdated = Time.now();
      };
      items.put(itemId, updatedItem);
      true;
    } else {
      false;
    };
  };

  public func updateLocation(itemId : ItemId, newLocation : Text) : async Bool {
    if (itemId < items.size()) {
      let item = items.get(itemId);
      let updatedItem : Item = {
        id = item.id;
        description = item.description;
        quantity = item.quantity;
        location = newLocation;
        lastUpdated = Time.now();
      };
      items.put(itemId, updatedItem);
      true;
    } else {
      false;
    };
  };

  public query func getAllItems() : async [Item] {
    Buffer.toArray(items);
  };

  public query func getItemsByLocation(location : Text) : async [Item] {
    let results = Buffer.Buffer<Item>(0);
    for (item in items.vals()) {
      if (Text.equal(item.location, location)) {
        results.add(item);
      };
    };
    Buffer.toArray(results);
  };

  public query func getLowStockItems(threshold : Nat) : async [Item] {
    let results = Buffer.Buffer<Item>(0);
    for (item in items.vals()) {
      if (item.quantity <= threshold) {
        results.add(item);
      };
    };
    Buffer.toArray(results);
  };
};