class currency{

  String name;
  String price;
  String supply;

  currency(this.name,this.price,this.supply);

  currency.fromMap(Map<String, dynamic> m)
      : this(m['name'], m['priceUsd'],m['supply']);

  Map<String, dynamic> toMap(){
    return{
      "name":name,
      "priceUsd":price,
      "supply":supply

    };
  }
}