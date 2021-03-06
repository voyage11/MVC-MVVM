# MVC - MVVM in a Todo iOS App

This is just a simple Todo iOS App project to show the transition from MVC implementation to MVVM Implementation. 

There are 4 branches in this project:-  
**MVC Branch:** It is implemented using MVC.  
**Master Branch:** It is converted from MVC to MVVM with the help of RxSwift.  
**MVVM-Coordinator:** It is MVVM + Coordinator pattern. Coordinator is basically a few classes that help in coordinating the app navigation. Coordinator also carries the responsibility to instantiate and inject dependencies for View Controller and View Model.  
**UnitTesting:** The codes from **MVVM-Coordinator** branch has been refactored so that unit testing can be conducted easier. ViewModel is the main targeted test unit. There is a still room for improvement on the testings.  

## MVC (Model, View, Controller)
This is a common software architectural pattern for most iOS projects. I have been using MVC for about 6 years of my iOS Career. 

If you have developed some complex iOS projects, you will notice that some view controllers may contain thousands lines of code. Any new change requests on those view controllers will be tough especially they contains codes from different iOS developers. MVC will eventually become "Massive View Controller" and hard to maintain.

Inside a MVC project, normally the codes have been distributed into a few layers:-  
**Model:** Contain structure of data for local storage, show on UIs, parameters on function or API requests.  
**View:** Storyboards, xib and associated view files such as UITableViewCell.  
**Controller:** In iOS, we only have View Controller. From the name itself, it shows that it is both view and controller. So, there is no clear distinguish between view and controller inside a View Controller. Sometimes, View Controller may contains some View related codes due to various reasons.  
**Utilities:** Contain small classes/structs/enums for constant declarations, utility/helper functions, settings/configurations.  
**Extension:** Extend the capability of View and View Controllers to synch the consistency and avoid codes repetition.  
**Service:** Contain codes related to data storage or API requests.  


## For MVVM (Model, View, View Model)
What exactly is MVVM? It is an improved software architectural pattern over the MVC. One of the main aims of MVVM is Separation of Concerns (SOC). When SOC is achieved, the Unit Testing can be conducted much easier.  

**Model, Utility, Extension, Service, View:** They are basically either stay the same or with minor changes.  
To reduce the responsibility of View Controller, View Model layer is created.  
**View Controller:** It will only interact with View Model and will not interact with Model and Service directly. It main function is to present data from View Model to show on UI or to get data from from UI and present to View Model.  
**View Model:** Contains codes related to business logic (eg: calling a Service, data manipulation and construct model).  


## For MVVM + Coordinator
Coordinator pattern has been added on top of MVVM to further remove the reponsibility related to app navigation from View Controller. Cooordinator classes will also be used to instantiate and inject dependencies for View Controller and View Model.  


## Personal Note
I started to use MVVM (together with RxSwift) about 1.5 years ago (Early 2019). My code is not perfect. I am a lifelong learner. I developed this simple Todo app to share the iOS app development using 2 different software architectures. Coordinator pattern and Unit Testing have been added on top of MVVM.

This Todo Project have the following functions:-
- Login
- Sign Up
- Add Todo Item
- Complete Todo Item
- Show Todo List
- Add Name on Profile
- Logout

The backend API is implemented using Firebase Authentication and Cloud Firestore. I hope you learn something new from this project. For more details on the project implementation, you visit this blog post: [MVVM and RxSwift - iOS Apps Development](https://mobileoop.com/mvvm-and-rxswift-ios-apps-development).
