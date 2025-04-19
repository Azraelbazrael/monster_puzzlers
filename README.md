# Monster Puzzlers
 
<!-- ABOUT THE PROJECT -->
Monster Puzzlers is a Roguelite Dungeon Crawler where you have the option to slay or befriend the beasts in your path. Will you slaughter one foe to feed another? Play fetch with your weapons? 
As it stands this project is currently in it's development phase!

<!-- Project information -->
### Built with

- [Godot 4.4][godot 4]
    - wirtten in GDscript

### Installation
1. Clone the repo
   ```sh
   git clone https://github.com/AzraelBazrael/DungeonGame.git
   ```
2. Install NPM packages
   ```sh
   npm install
3. Change git remote url to avoid accidental pushes to base project
   ```sh
   git remote set-url origin AzraelBazrael/DungeonGame
   git remote -v # confirm the changes
<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Road Map

- [ ] environment
    - [ ] Create randomly generated map 
    - [ ] generate new maps between floors
    - [ ] levels and environments change when the player progresses further

- [ ] winning/losing
    - [ ] "win" condition between floors
    - [ ] "lose" condition between floors
    - [ ] player gains exp after level is passed
    - [ ] player level / floor is reset upon death

- [ ] inventory system
    - [ ] items are dropped from rocks/enemies
    - [ ] collectable items
    - [ ] player can hold items
    - [ ] items can be crafted

- [ ] enemies
    - [ ] big ending boss
    - [ ] different types of enemies
    - [ ] basic state machine
    - [ ] enemy can kill player
    - [ ] player can befriend monsters

<p align="right">(<a href="#readme-top">back to top</a>)</p>
<!-- MARKDOWN LINKS & IMAGES -->
[godot 4]: https://godotengine.org/