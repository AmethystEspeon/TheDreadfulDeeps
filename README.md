# Healing Game (WIP, Name TBD)

INSTALLATION/COMPILING
------------------

This game is written in Lua using the Love2D framework. In order to turn it into a .exe game you must have [LÖVE](https://love2d.org/) installed and follow the steps found on the [Game Distribution](https://love2d.org/wiki/Game_Distribution) page on their wiki.
It should be able to run on both Windows or macOS/Linux.


STARTING THE GAME
------------------------
Once you start the game, the initial game screen will be your spellbook page. At the moment, you only start with Heal as your basic spell. In order to be able to use your spells in combat you must click and drag them onto your action bar at the bottom.

![Initial Spellbook Preview](https://user-images.githubusercontent.com/75288346/213581892-a1bc3d83-0412-4e51-9f73-93150828aff6.png)

*NOTE: Multiple copies of the same spell do not give extra usages. They all share the same cooldown*

Once you are done with setting up your spells how you want, click the X in the top right-hand corner of your spellbook to begin the next wave.

THE FIGHT
------------------------
In the fight, you play as the healer of a 5 man adventurer group. Your main goal is to keep everyone alive. At the bottom of your screen is your action bar. It shows your selected spells, the button to press to use them, and their cooldown. Above the action bar is your party's healthbars. In order from left to right it is your tank, yourself (the healer), and then your three damage dealers (DPS characters). Above that is your enemy's healthbars.

![Fight Preview](https://user-images.githubusercontent.com/75288346/213583860-13631f64-b515-4754-86c5-3ab2bcea9164.png)

In order to cast your spells you must hover your mouse over an applicable target (allies for heals, enemies for damage, no hovering needed for something that has no target) and press the corresponding key. You win the round if all of the enemies' hp reaches 0 and you lose if everyone's hp in your party reaches 0.

THE REWARDS
-----------------------
When you win a round, you will gain a reward! This can be a new spell, someone to swap an ally with, or an upgrade to one of your abilities! Simply click the 'choose' button near the bottom of the reward you desire! After you choose, you will be sent to the spellbook screen to organize your spells before your next fight!

![Reward Preview](https://user-images.githubusercontent.com/75288346/213584412-2ad3b250-598b-4469-a086-e173e23200da.png)
