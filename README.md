# Rails Engine
![GitHub top language](https://img.shields.io/github/languages/top/naomiyocum/rails-engine?color=yellow)

## Table of Contents
* [General Info](#general-info)
* [Learning Goals](#learning-goals)
* [Technologies](#technologies)
* [Usage](#usage)
* [API Endpoints](#api-endpoints)
  * [Merchant Endpoints](#merchant-endpoints)
  * [Item Endpoints](#item-endpoints)

## General Info
Rails Engine is a basic RESTful API that provides information about items and merchants ([endpoints](#api-endpoints)). We were to work in a service-oriented architecture by first exposing the data through this API that the front end could consume later.

[Here](https://github.com/naomiyocum/rails_engine_fe) is the front end side I worked on to consume my Rails Engine API.

## Learning Goals
- Expose an API
- Use serializers to format JSON responses
- Test API exposure
- Use SQL and AR to gather data

## Technologies
- Ruby 2.7.4
- Rails 5.2.8

## Usage

Clone the repo by running `git clone` with the copied URL onto your local machine

Then, run the following commands:
```
cd rails-engine
bundle install
rails db:{drop,create,migrate,seed}
rails s
```

Lastly, head to your web browser or Postman. The base URL is `localhost:3000` and endpoints are listed below.

## API Endpoints

### Merchant Endpoints
- ### GET /api/v1/merchants
  > fetch all merchants
<br> 

- ### GET /api/v1/merchant/{merchant_id}
  > fetch a single merchant
  
  | Path Parameter        | Type          |  |
  | ------------- |:-------------:| -----:|
  | merchant_id      | integer | Required |
  
<br> 

- ### GET /api/v1/merchants/{merchant_id}/items
  > fetch all items for a given merchant
  
  | Path Parameter        | Type          |  |
  | ------------- |:-------------:| -----:|
  | merchant_id      | integer | Required |
 <br> 
  
- ### GET /api/v1/merchants/find?name={search}
  > fetch a single merchant matching a search term
  
  | Query        | Type          |  |
  | ------------- |:-------------:| -----:|
  | search      | string | Required |
 <br>
 
- ### GET /api/v1/merchants/find_all?name={search}
  > fetch all merchants matching a search term
  
  | Query        | Type          |  |
  | ------------- |:-------------:| -----:|
  | search      | string | Required |
<br>

### Item Endpoints
- ### GET /api/v1/items
  > fetch all items
<br>  

- ### GET /api/v1/items/{item_id}
  > fetch a single item
  
    | Path Parameter        | Type          |  |
  | ------------- |:-------------:| -----:|
  | item_id      | integer | Required |
<br>  
  
- ### POST /api/v1/items
  > create an item

  | Body       | Type           |   |
  | ------------- |:-------------:| -----:|
  | name      | string | Required |
  | description      | string      |   Required |
  | unit_price | float      |    Required |
  | merchant_id    |     integer          |   Required    |
  
  Example:
  ```
  {
    "name": "Candle",
    "description": "ignitable wick embedded in wax",
    "unit_price": 6.99,
    "merchant_id": 2
  }
  ```
 <br> 

- ### PATCH /api/v1/items/{item_id}
  > edit an item
  
  | Path Parameter        | Type          |  |
  | ------------- |:-------------:| -----:|
  | item_id      | integer | Required |
  
  Update at least one attribute below
  
  | Body       | Type           |   |
  | ------------- |:-------------:| -----:|
  | name      | string | Optional |
  | description      | string      |   Optional |
  | unit_price | float      |    Optional |
  | merchant_id    |     integer          |   Optional    |

<br>

- ### DELETE /api/v1/items/{item_id}
  > delete an item
  
  | Path Parameter        | Type          |  |
  | ------------- |:-------------:| -----:|
  | item_id      | integer | Required |
 <br>
 
- ### GET /api/v1/items/{item_id}/merchant
  > fetch merchant data given item
  
  | Path Parameter        | Type          |  |
  | ------------- |:-------------:| -----:|
  | item_id      | integer | Required |
<br>

- ### GET /api/v1/items/find
  > find a single item matching a search term (two searches available)

  Search by name
  | Query        | Type          |  |
  | ------------- |:-------------:| -----:|
  | `?name={search}`      | string | Required |
  
  Search by price (returns equal to/greater than min_price, equal to/less than max_price, or in a range of both prices)
  | Query      | Type           |   |
  | ------------- |:-------------:| -----:|
  | `?min_price={search}`      | float | Optional |
  | `?max_price={search}`      | float      |   Optional |
  

- ### GET /api/v1/items/find_all
  > find all items matching a search term (two searches available)

  Search by name
  | Query        | Type          |  |
  | ------------- |:-------------:| -----:|
  | `?name={search}`      | string | Required |
  
  Search by price (returns equal to/greater than min_price, equal to/less than max_price, or in a range of both prices)
  | Query      | Type           |   |
  | ------------- |:-------------:| -----:|
  | `?min_price={search}`      | float | Optional |
  | `?max_price={search}`      | float      |   Optional |
  <br>
  
  Valid examples:
  ```
  GET /api/v1/items/find?name=ring
  GET /api/v1/items/find?min_price=50
  GET /api/v1/items/find?max_price=150
  GET /api/v1/items/find?max_price=150&min_price=50
  ```
  
  Invalid examples:
  ```
  GET /api/v1/item/find
  GET /api/v1/item/find?name=
  GET /api/v1/items/find?name=ring&min_price=50
  GET /api/v1/items/find?name=ring&max_price=50
  GET /api/v1/items/find?name=ring&min_price=50&max_price=250
  ```
  
