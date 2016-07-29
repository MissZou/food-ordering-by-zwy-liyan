# food-ordering-by-zwy-liyan

Dissertation in HKU. Developing a food ordering system which is a copycat of [ele](https://www.ele.me/) and [Meituan waimai](http://waimai.meituan.com/). 

**This program is not mean to plagiarize but exercise.**


Front-end: iOS native App, PC and mobile web page. 
Back-end: Node.js + mongodb.

iOS is built in Objective-C(FOSinOC). I have write a swift version but I do not update it for a long time.

iOS App need to set up node.js server to run fully or you can annotation code at 

**LoginViewController.m**
- (IBAction)loginButtonClicked:(id)sender

And can log into the app.

------

这个项目是作为在香港大学授课试硕士的一个小毕业设计，我们模仿[饿了么](https://www.ele.me/) 和 [美团外卖](http://waimai.meituan.com/)写了一个类似的订餐软件。做这个项目是为了更多的练习。

我负责iOS的全部开发和80%的Node.js开发。

----

Now the iOS Objective-C version looks like:      

Login and tutorial view.     

![tutorial view](https://github.com/Thanatos-L/food-ordering-by-zwy-liyan/blob/master/readme/login.gif)


MainView, could search shop by location.     

![Alt Text](https://github.com/Thanatos-L/food-ordering-by-zwy-liyan/blob/master/readme/MainView.gif)


Old detailedshopView, too many bugs and now been replaced by a new one.     

![Alt Text](https://github.com/Thanatos-L/food-ordering-by-zwy-liyan/blob/master/readme/detailedview.gif)


Add/delete item in cart.      

![Alt Text](https://github.com/Thanatos-L/food-ordering-by-zwy-liyan/blob/master/readme/cartView.gif)


Food view      

![Alt Text](https://github.com/Thanatos-L/food-ordering-by-zwy-liyan/blob/master/readme/foodView.gif)


Place order view      

![Alt Text](https://github.com/Thanatos-L/food-ordering-by-zwy-liyan/blob/master/readme/Placeorder.gif)

###So far we have done

**Node.js**

User Schema/Router could perform:
```
register
forgotPassword
changePassword
login
Account
findAccount
findAccountById
uploadAvatar
addAddress
updateAddress
deleteAddress
addLocation
deleteLocation
addItemToCart
findCartItem
findCartItemById
modifyItemToCart
deleteItemOfCart
addOrder
deleteOrder
findOrderByUserId
addFavoriteShop
findFavoriteShop
deleteFavoriteShop,
addFavoriteItem
findFavoriteItem
deleteFavoriteItem
```

-------

Shop Schema/Router could perform:
```
createShop
findShop
findShopById
changeShopInfo
uploadShopCover
addDish
changeDishInfo
forgotPassword
changePassword
login
addDishPic
queryNearShops
findNearShops
findShopByName
findShopsAndDishs
findItemById
addOrder
findOrderByShopId
```
------
Order Schema could perform:
```
addOrder
changeOrderStatus
```


##Infomation Architecture

Red blocks need further development.

**Node.js**

![Node.js-IA.png](https://github.com/Thanatos-L/food-ordering-by-zwy-liyan/blob/master/readme/Node.js-IA.png)

**iOS**

![iOS-IA.png](https://github.com/Thanatos-L/food-ordering-by-zwy-liyan/blob/master/readme/iOS-IA.png)