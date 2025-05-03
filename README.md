# Monster Puzzlers
 
<!-- ABOUT THE PROJECT -->
Monster puzzlers is a monster-taming dungeon crawler currently in development. No playable builds are available yet.

<!-- Project information -->
### Built with

- <a href="https://godotengine.org/">Godot 4.4 </a>
    - written in GDscript

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
<!-- <p align="right">(<a href="#readme-top">back to top</a>)</p>  -->


## Road Map

- [ ] environment
    - [ ] implement multiple tilemaps
    - [x] Create randomly generated map 
    - [x] generate new maps between floors

 - [ ] player
   - [ ] different player resources
   - [x] player depletes stamina when using an item
   - [x] player depletes health when attacked
   - [x] player can die
   - [ ] player can level up
        
- [ ] Levels
  - [ ] Keep track of levels when one is passed
  - [ ] change biomes when reaching different thresholds randomly
  - [ ] reset level when dead
  - [ ] have resources holding arrays of different items and enemies to spawn in different biomes

 
- [ ] winning/losing
    - [x] "win" condition between floors
    - [x] "lose" condition between floors
    - [ ] player gains exp after level is passed
    - [ ] player level / floor is reset upon death

- [ ] inventory system
    - [x] items are dropped from rocks
    - [ ] enemies drop items when killed
    - [x] collectable items
    - [x] player can hold items
    - [x] items can be crafted
    - [ ] crafting instructions saved after dying

- [ ] enemies
    - [ ] big ending boss
    - [x] different types of enemies
    - [x] basic state machine
    - [x] enemy can kill player
    - [ ] player can befriend monsters

## Credits
* [Weapon pack artwork](https://umoral.itch.io/daggers-pack)

<p align="right">(For more information please refer to the <a href="https://github.com/Azraelbazrael/monster_puzzlers/blob/main/DOCUMENTATION.md">documentation</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- [godot 4]: https://godotengine.org/  -->
