# Ruby Bank

## Introduction

This application simulates a bank where users can deposit money and transfer money to other users.

## Notes & caveats
This is a very simple bank-app. I can easily spent weeks on it to add a lot of extra features. In this chapter and in the chapter the chapter TODO's & limitations, I describe features that you can implement, but not required by the excercise.

Please note that this application can not run in real-life. There are too much limitations. For example:
* I used I18n so we can easily internatiolize the application. Currently the application is only in Dutch.
* For simplicity I used a very basic login-system using 'bcrypt'. For a more advanced system if you need for example 'roles'; Devise might be a good idea.
* For performance issues I choose to save the current balance in the bankaccount as 'duplicated data', so we do not have to sum all transactions every time we retrieve the current balance. For now it should be fine if we sum all the transactions. If the app become larger and we have a lot transactions it may lead to performance issues. In my opinion it is the best to overcome the performance issues on the first hand instead of later on. Please note that in the tests, because of using the fixtures, the current_balance is not set. Because I could not find any other bug, then the 'bug' in the tests, I still believe it is the best solution to use 'duplicated data' on the current balance.
* The precesion of the balance and the transactions amount is only '10'.
* The used currency is always euro's.
* Bigdecimals with a too large scale (greather than 2) are automatically converted to a scale of 2 by the database.
* For simplicity I used a 'dot' instead of a comma for the cents in every amount.
* Weak passwords are allowed.


## Installation

Before running the application, Please setup your database with SQLite and run the following command
```
bundle exec rake db:migrate
```

You can run the (Rails) console as follows
```
bundle exec rails c
```

First you need to create a user via the console as follows:
```
user = User.create(firstname: "Jeroen", lastname: "Van Ingen", email: "jeroeningen@gmail.com", password: "123456", password_confirmation: "123456")
```

And then deposit e.g. EUR. 1000.00 to the bankaccount of the user via the GUI or via the console: as follows
```
user.deposit(1000) # "U heeft EUR. 1000.00 gestort."
```

You can retrieve the current balance via the GUI or via the console as follows:
```
user.current_balance # "EUR. 1000.00"
```

Furthermore you can deposit money and transfer money to other users via the GUI.

And then to run your server to see transactions, do deposits and transfer money as follows:
```
bundle exec rails s
```


## Functional design

The stucture of the database is very simple. A user can have one bankacount. Every bankaccount can have many transactions.

When a user do a deposit; bascally a transaction is added with a positive amount.

When a user A transfers money to user B, two transactions are added. One outgoing tranaction with a negative amount for the bankaccount of user A and one incoming transaction with a positive amount for the bankaccount of user B.

Every time a transaction is added to a bankaccount; the current balance on the bankaccount is updated.

Every user has an overview of their transactions.


## Testing

For testing I used minitest with the Rspec syntax.

Please run the tests as follows
```
bundle exec rake
```
This app has a lot of tests, because I assume DigID is an application that must be highly tested.

Please note that I use a lot 'assert_equal'. That is because I could not get the 'assert' function properly working.

As you can see in the tests I use the password '123456'. As long as weak passwords are allowed, this is OK.


## Known bugs
* The application accepts BigDecimals with a scale larger then 2 as input. e.g. EUR. 10.003. Nevertheless, the database will round it to a scale of 2 itself. But still its is ugly, that the application accepts a scale larger then 2 as input.

## TODO's & limitations
Please note that according to the excercise the following points are not required, but for me personally it would be the next points to implement
* Accepts BigDecimals with a scale not larger then 2 as input.
* Strong passwords are not implemented.
* implement a role-based system (like Devise) to add roles
* Add a capistrano-script or even better, create a Docker image for easy deployment
* Localize the currencies instead of always using a 'dot' for the cents.
* Implement other currencies, including a currency-conversion

## Contact
If you have any further questions, please contact me at jeroeningen@gmail.com
