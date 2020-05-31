# MVC -> MVVM

This is just a simply project to show the transition from MVC to MVVM. 


## MVC (Model, View, Controller)
This is a common software development pattern for most iOS projects. I have been using MVC for about 6 years of my iOS Career. 
If you have developed some complex iOS projects, you will notice that some view contrrollers may contain thousands lines of code. Any new change requests on those view controllers will be tough especially they contains codes from different iOS developers. MVC will eventually become "Massive View Controller" and hard to maintain.


## For MVVM (Model, View, View Model)
What exactly is MVVM? It is an improved software development patterm over the MVC. 
Model - The same on MVC which consist of data.
View - Consists of both View and View Controller.
View Model - Codes related to networking and data manipulation are separated from View Controller and placed under this layer. It also means that View Controller will have less responsibility and less code.

I just started to use MVVM (together with RxSwift) about 1.5 years ago. 
