package com.city.dao;

import java.util.List;
import com.city.pojo.MarketplaceItem;

public interface MarketplaceDao {
    boolean addItem(MarketplaceItem item);
    List<MarketplaceItem> getAllItems();
    List<MarketplaceItem> getItemsByCategory(String category);
    List<MarketplaceItem> getItemsByCity(String city);
    boolean deleteItem(int id);
}
