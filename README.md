Kii Ruby Library
==========

Kii Cloud Library for Ruby. This library provides APIs for Kii Cloud and data structures.

Currently in development, limited support for now.

Getting started
===============

Please register at https://developer.kii.com/ and fill in your config file.

you can install the dependencies with

    bundle install --path vendor

and get a command shell to run examples :

    bundle exec pry -r Kii

Run the tests with

    bundle exec rspec


You can init your app with


    @app = KiiApp.new
	@app.get_admin_token


create app scope objects like :

    @data = {'a' => 'b', 'c' => 'd'}
	@object = @app.new_object(@data)
	@object.create

if you want to create in a specific bucket, you can use

	@object = @app.buckets("my_bucket").new_object(@data)
	
create users like :

    @user = @app.new_user({
	    login_name: 'your_username',
		display_name: 'Your Name',
		country: 'JP',
        password: '123456',
        email: 'your@mail.com',
        phone_number: '09012341234'
        })
	@user.signup

you can create user scope objects like

	@object = @user.new_object(@data) # default bucket which is 'mydata'
	@object = @user.buckets("my_bucket").new_object(@data)


etc. (moar to follow...)
					

APIs
====

Please check http://documentation.kii.com/rest/

Entities
========

KiiUser
-------
Represents Application user. User is authorized by
- username and password
- email and password
- phone and password

KiiGroup (not yet)
--------
Represents Group in Kii Cloud. Group consists of
- Member : A list of KiiUser
- Name : The name of group
- Owner : Group owner

KiiBucket
---------
Represents Bucket in Kii Cloud. Bucket consists of
- Owner : Bucket owner. Application / Group / User can be an owner of bucket.
- Name : The name of bucket.

KiiTopic (not yet)
---------
Represents Topic in Kii Cloud. Topic consists of
- Owner : Topic owner. Application / Group / User can be an owner of topic.
- Name : The name of topic.

This Readme is shamelessly copied from fkm's PHP lib :) check it out at :
https://github.com/fkmhrk/kiilib_php
