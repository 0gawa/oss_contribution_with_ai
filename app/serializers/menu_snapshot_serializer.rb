class MenuSnapshotSerializer
  def self.serialize(menu)
    {
      "id" => menu.id,
      "name" => menu.name,
      "price" => menu.price,
      "category" => menu.category
    }
  end
end
