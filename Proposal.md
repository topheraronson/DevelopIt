# Develop it

# Proposal

---
 - __What problem does your app solve?__
&ensp; Keeping track of time for each step during the film development process. 

- __Be as specific as possible; how does your app solve the problem?__
&ensp; It allows the user to create multiple timers that can run consecutively. The user has the option to set a secondary timer that runs concurrently with the main timer to remind them to agitate the chemicals while developing the film.  

- __What is the mission statement?__
&ensp; Allow film photography enthusiasts to have a reliable way to keep track of time while developing their film.

# Features

---

- __What features are required for your minimum viable product?__
&ensp;A main view holding a timer. A secondary view containing a second timer running concurrently with the main timer. Everytime the second timer ends it sets off a ding sound and resets itself. A collection view holding a list of set timers. A view for creating and setting the timers. Away to save seeting to create your own presets

- __What features may you wish to put in a future release?__
&ensp;I'd like to include presets for the top film brands and top chemical brands and the ability to set a color theme for the app. 

- __What do the top 3 similar apps do for their users?__
&ensp;They all have the ability to set multiple timers, though some limit the number allowed. The give you the abiility to name your timers. Their timers are usually hard to set. Only one lets you save presets.

# Frameworks

---

I won't be using any third party frameworks or APIs

# Target Audience

---

- __Who is your target audience? Be specific.__
&ensp;Film photographers that develop their own film
- __What feedback have you gotten from potential users?__
&ensp;I have talked with several other film photofraphers I know about what they want in an app
- __Have you validated the problem and your solution with your target audience? How?__
&ensp; Yes I shared my ideas and asked for opinions and changed my ideas accordingly. 

# Monetization

---

- __What avenues of income does your app provide?__
I may sell it for $0.99 but most likely it will be a free app without any ads so there will not be any form of income.

- What features can you charge for in your app?
&ensp;N/A
- Is there a possibility of a subscription model?
&ensp;N/A

# Model

---

- __What data do you need?__
&ensp; Information about the timer to save as a preset.

- __Where will you get the data?__
&ensp;The user will input it.

- __Will your data be stored locally or remotely?__
&ensp;Locally

- __How is your data related?__
&ensp;It will be a one to many relationship between a preset and the timers.
- __How will your data be represented in your app?__
&ensp;Presets will be available in a table view accessible from the bottom tool bar. 

- __List all model objects with their properties and initializers.__
&ensp; A Presets model that contains a group of Timers objects. Each Timer object will have a timeAmount property and an agitationTime property.

# Views

---

- __What views do you need to create to meet each feature in your app?__
&ensp;I will need two view controllers and one table view controller.

- __How will the user navigate to each view?__
&ensp;Pages will be presented modaly and exited via a button tap

- __Revisit this regularly. Simplify each time. Focus on the user.__
[Main Screen Mock](https://adobe.ly/2ItROWb)
[Set Timer Mock](https://adobe.ly/31W7MAi)
- __What UIKit elements/animations will you use to create each view?__
There needs to be a circular bar animation linked with the timer on the main page. There will be a collection view embeded in the main view. On the set timer view there needs to be a date picker and a slider to set the timers.

# Controllers

---

- __What controllers do you need for your app? (Consider model, network, purchase, dataSource, and other specialized controllers)__
&ensp;I will need one model controller, two view controllers, and one table view controller.
- __What will each controller need to do?__
&ensp;The model controller will load the prsets from the persistent store and fill the timers with the appropriate data. The first view controller will controller the interface for the main screen. The second view controller will controller the interface for the set timer screen. The table view controller will controller the interface for the preset screen.
- __What frameworks do you need to integrate?__
&ensp;N/A
- Write out properties and methods for each controller object

# Research

---

- Research thouroughly before writing a single line of code. Solidify the features of your app conceptually before implementation. Spend the weekend researching so you can hit the ground running on Monday.

# Prototype Key Feature(s)

---

- This is the “bread and butter” of the app, this is what makes your app yours. Calculate how long it takes to implement these features and triple the time estimated. That way you’ll have plenty of time to finish. It is preferred to drop features and spend more time working on your MVP features if needed.

# Suggested Plan:

---

**Monday:**

- Set up view hierarchy
- Implement model
- Controllers with mock data

**Tuesday:**

- Wire-up views
- Implement controllers

**Wednesday:**

- Ensure that the Key Feature(s) is/are working.
- Visual design.
- Implement monetization (if applicable).

**Thursday:**

- Finish features

**Friday:**

- Polish visual design