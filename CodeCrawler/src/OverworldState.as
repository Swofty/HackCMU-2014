package 
{
	import mx.collections.*;
	
	import adobe.utils.CustomActions;
	import flash.text.engine.ElementFormat;
	import mx.core.ButtonAsset;
	import mx.core.FlexApplicationBootstrap;
	import mx.core.FlexSprite;
	import org.flixel.*;
	import flash.display.Graphics;
	import flash.utils.getQualifiedSuperclassName; //used to figure out the super class of some classes
	
	public class OverworldState extends FlxState
	{
		FlxG.debug;
		//********Map building stuff*************************
		//constants for tile sizes
		private const TILEWIDTH:uint = 50;
		private const TILEHEIGHT:uint = 50;
		
		private var map:FlxTilemap;	//stores the actual map that is uploaded		
		[Embed(source = '../assets/maps/test.txt', mimeType = 'application/octet-stream')] private var map_data:Class; //stores the string that the map is made out of
		
		[Embed(source = '../assets/gfx/wall.png')] private var Wall_Tiles:Class;		//Embed wall tileset to use
		[Embed(source = '../assets/gfx/floor.png')] private var Floor_Tiles:Class;		//Embed floor tileset to use
		
		//******Background Music*****************************
		//Hyrule Temple
		[Embed(source = "../assets/music/Overworld.mp3")] private var OverworldBGM:Class;
		
		//*****Actual game things****************************
		private var player:Player ;
		private var room_layout_list:ArrayList = new ArrayList();
		
		private var current_room:Room;
		private var room_title:FlxText;
		
		private var variable_display:FlxText;
		private var constant_display:FlxText;
		private var expression_display:FlxText;

		private var code_display:FlxText;
		private var code_tracker:FlxSprite;
		
		override public function create():void 
		{	
			//****MUSIC AND SFX******************************
			//FlxG.play(OverworldBGM);
			
			//**********Mapping shit*************************
			/*
			map = new FlxTilemap();
			
			map.loadMap(new map_data, Floor_Tiles, TILEWIDTH, TILEHEIGHT);
			add(map);
			*/
			
			player = new Player(100, 100);
			
			var c:Constant = new Constant("int", 5, 1 * TILEWIDTH, 1 * TILEHEIGHT);
			room_layout_list.addItem(new RoomLayout("fib"));
			current_room = (RoomLayout)(room_layout_list.getItemAt(0)).generateRoom(c, null);
			current_room.loadMap(new map_data, Floor_Tiles, TILEWIDTH, TILEHEIGHT);	
			current_room.instantiateTemplateItem(new Door(new RoomLayout("fib"),-1, -1));
			add(current_room);
			
			for (var i:int = 0; i < current_room.items.length; i++)
			{
				add((Item)(current_room.items.getItemAt(i)));
			}
			
			add(player);
			
			room_title = new FlxText(200, 250,600, "room title!")//floorArray[0].name)
			room_title.size = room_title.size*3;

			
			variable_display = new FlxText(0, 600, 200, "variables!")//floorArray[0].name)
			variable_display.size = 2 * variable_display.size;
			constant_display = new FlxText(200, 600, 200, "constants!")//floorArray[0].name)
			constant_display.size = 2 * constant_display.size;
			expression_display = new FlxText(400, 600, 400, "expressions!")//floorArray[0].name)
			expression_display.size = 2 * expression_display.size;
			
			code_display = new FlxText(800, 0, 150, "code!")
			code_display.size = 2 * code_display.size;
			
			code_tracker = new FlxSprite(800, 0);
			code_tracker.width = 400;
			code_tracker.alpha = 0.5;
			
			add(room_title);
			add(variable_display);
			add(constant_display);
			add(expression_display);
			add(code_display);
			add(code_tracker);
			
			super.create();
		}
		override public function update():void 
		{
			if (player.x < 0) {
				/*copy this code into all of the other checks for each door*/
				for (i = 0; i < current_room.items.length; i++)
				{
					if (considered_item is Door)
					{
						var considered_door:Door = (Door)(current_room.items.getItemAt(i));
						if (considered_door.associated_wall == Room.RIGHT) 
						{
							if (considered_door.door_type == Door.RETURN) 
							{
								if (current_room.parent_room == null) 
								{
									FlxG.switchState(new VictoryState((Item)(player.constant_list.getItemAt(0)).getDescription()));
									return;
								}
								current_room = current_room.parent_room;
							}
							else
							{
								if (considered_door.linked_room == null)
									current_room = considered_door.linked_room_layout.generateRoom
											((Constant)(player.constant_list.getItemAt(0)), current_room);
								else
									current_room = considered_door.linked_room;
							}
						}
					}
				}
				player.x = 800 - player.height;
			}
			if (player.x > 800 - player.height) {
				
				player.x = 0;
			}
			if (player.y < 0) {
				
				player.y = 600 - player.width;
			}
			if (player.y > 600 - player.height) {
				
				player.y = 0;
			}
			//This stuff collides the player with the map, it smooths edges to stop annoying derpy things. 
			if (FlxG.collide(player, current_room))
			{
				//This smooths a play's maneuverying around square objects if they are colliding on the top when they want to move sideways
				if ((current_room.getTile((player.x + player.width) / TILEWIDTH, (player.y) / TILEHEIGHT) != 0
					&& current_room.getTile((player.x + player.width) / TILEWIDTH, (player.y + (2 * player.height / 3)) / TILEHEIGHT) == 0)
					|| (current_room.getTile((player.x-1) / TILEWIDTH, (player.y) / TILEHEIGHT) != 0
					&& current_room.getTile((player.x-1) / TILEWIDTH, (player.y + (2 * player.height / 3)) / TILEHEIGHT) == 0)
					)
					{
						player.y += 2;
					}	
				//This smooths a play's maneuverying around square objects if they are colliding on the bottom when they want to move sideways
				if ((current_room.getTile((player.x + player.width) / TILEWIDTH, (player.y + player.height-1) / TILEHEIGHT) != 0
					&& current_room.getTile((player.x + player.width) / TILEWIDTH, (player.y + (player.height / 3)) / TILEHEIGHT) == 0)
					|| (current_room.getTile((player.x-1) / TILEWIDTH, (player.y + player.height-1) / TILEHEIGHT) != 0
					&& current_room.getTile((player.x-1) / TILEWIDTH, (player.y + (player.height / 3)) / TILEHEIGHT) == 0)
					)
					{
						player.y -= 2;
					}
				//This smooths a play's maneuverying around square objects if they are colliding on the left when they want to move vertically
				if ((current_room.getTile((player.x) / TILEWIDTH, (player.y-1) / TILEHEIGHT) != 0
					&& current_room.getTile((player.x + (2*player.width)/3) / TILEWIDTH, (player.y-1) / TILEHEIGHT) == 0)
					|| (current_room.getTile((player.x) / TILEWIDTH, (player.y+player.height) / TILEHEIGHT) != 0
					&& current_room.getTile((player.x + (2*player.width)/3) / TILEWIDTH, (player.y+player.height) / TILEHEIGHT) == 0)
					)
					{
						player.x += 2;
					}
				//This smooths a play's maneuverying around square objects if they are colliding on the right when they want to move vertically
				if ((current_room.getTile((player.x + player.width-1) / TILEWIDTH, (player.y-1) / TILEHEIGHT) != 0
					&& current_room.getTile((player.x + (player.width)/3) / TILEWIDTH, (player.y-1) / TILEHEIGHT) == 0)
					|| (current_room.getTile((player.x + player.width-1) / TILEWIDTH, (player.y+player.height) / TILEHEIGHT) != 0
					&& current_room.getTile((player.x + (player.width/3)) / TILEWIDTH, (player.y + player.height) / TILEHEIGHT) == 0)
					)
					{
						player.x -= 2;
					}
			}

			room_title.text = "Welcome to room " + current_room.room_title;
			
			var i:int = 0;
			constant_display.text = "Constants: \n";
			for (i= 0; i < player.constant_list.length; i++)
			{
				constant_display.text += (Item)(player.constant_list.getItemAt(i)).getDescription() + "\n";
			}
			
			variable_display.text = "Variables: \n";
			for (i = 0; i < player.variable_list.length; i++)
			{
				variable_display.text += (Item)(player.variable_list.getItemAt(i)).getDescription() + "\n";	
			}
			
			
			expression_display.text = "Current Expression: \n"
			var considered_item:Item;
			for (i = 0; i < current_room.items.length; i++)
			{
				considered_item = (Item)(current_room.items.getItemAt(i));
				if (!(considered_item is Door))
				{
					if (player.overlaps(considered_item)) {
						expression_display.text += considered_item.getDescription();
					}
				}
				else
				{
					if (FlxG.collide(player, considered_item)) {
						expression_display.text += considered_item.getDescription();
					}
				}
			}	
			
			if (FlxG.keys.SPACE)
			{
				for (i = 0; i < current_room.items.length; i++)
				{
					considered_item = (Item)(current_room.items.getItemAt(i));
					if (!(considered_item is Door))
					{
						if (player.overlaps(considered_item))
							considered_item.doAction(player, current_room);
					}
					else
					{
						if (FlxG.collide(player, considered_item))
							considered_item.doAction(player, current_room);
					}
				}
			}

			/*
			if (FlxG.overlap(player, floor.stairGroup))
			{
				var stairTraversed:Stairs = floor.determineStair(player);
				if (stairTraversed.descend == true)
				{
					loadMap(stairTraversed.below);
					player.x = 100;
					player.y = 100;
					for each (var stair:Stairs in floor.stairGroup.members)
					{
						if (stair.above == stairTraversed.above)
						{
							player.x = stair.x - 100;
							player.y = stair.y - 100;
						}
					}
					FlxG.camera.setBounds(0, 0, floor.map.width, floor.map.height);
				}
				else // (stairTraversed.descend == false)
				{
					loadMap(stairTraversed.above);
					player.x = 100;
					player.y = 100;
					for each (var stair:Stairs in floor.stairGroup.members)
					{
						if (stair.below == stairTraversed.below)
						{
							player.x = stair.x - 100;
							player.y = stair.y - 100;
						}
					}
					FlxG.camera.setBounds(0, 0, floor.map.width, floor.map.height);
				}
			}
			
			trace(floorNameArray[floorArray.indexOf(floor)]);
			*/
			super.update();
		}
		
		
		//This function will take our spec and generates and array that stores all of our .txt files
		//These .txt files are the floors of our dungeons.
		/*
		public function generateMaps():void
		{
			var myMapSpec:String = spec;
			var floornumber:int = parseInt(myMapSpec.substring(0, myMapSpec.indexOf('\n')));//this holds the total number of floors
			floorArray = new Array(floornumber);												//this holds all of the Floors.

			myMapSpec = myMapSpec.substring(myMapSpec.indexOf('\n') + 1);
			
			for (var j:int = 0; j < floornumber; j++)
			{
				floor = new Floor();
				floorArray[j] = floor;
				
				myMapSpec = myMapSpec.substring(myMapSpec.indexOf(' ') + 1);
				//this code will get us the floor that precedes each floor if applicable.
				floor.name = myMapSpec.substring(0, myMapSpec.indexOf(' '));
				myMapSpec = myMapSpec.substring(myMapSpec.indexOf(' ') + 1);
				
				floor.parentname= myMapSpec.substring(0, myMapSpec.indexOf(' '));
				myMapSpec = myMapSpec.substring(myMapSpec.indexOf(' ') + 1);		
				
				floor.files = parseInt(myMapSpec.substring(0, myMapSpec.indexOf(' ')));
				myMapSpec = myMapSpec.substring(myMapSpec.indexOf(' ') + 1);
				
				floor.subdirectories = parseInt(myMapSpec.substring(0, myMapSpec.indexOf('\n')));
				myMapSpec = myMapSpec.substring(myMapSpec.indexOf('\n') + 1);
			}
			myMapSpec = myMapSpec.substring(myMapSpec.indexOf(';')+2);
			
			for (var i:int = 0; i < floornumber; i++)
			{
				//this code will get us the actual data about the floor and make it.
				mapdata = myMapSpec.substring(0, myMapSpec.indexOf('\n\n\n'));
				map = new FlxTilemap();
				map.loadMap(mapdata, Tiles, TILEWIDTH, TILEHEIGHT);
				
				floorArray[i].map = map;
				
				myMapSpec = myMapSpec.substring(myMapSpec.indexOf('\n\n\n')+3);
			}
			
			
			generateStairs();
			this.floor = floorArray[0];
			add(this.floor.map);
			add(this.floor.stairGroup);
		}
		*/
		/*
		public function generateStairs():void
		{
			for (var i: int = 0; i < floorArray.length; i++)
			{
				var a:Floor = floorArray[i]
				for (var j: int = 0; j < i; j++)
				{
					var b:Floor = floorArray[j]
					if (b.parentname == a.name || a.parentname == b.name)
					{
						var parent:Floor;
						var child:Floor;
						if (b.parentname == a.name)
						{
							parent = a;
							child = b;
						}
						else //if (a.parentname == b.name)
						{
							parent = b;
							child = a;
						}
					
						//This takes care of the descending staircases
						var stairpoint:FlxPoint = findStairs(parent.map);
						var stair:Stairs = new Stairs(stairpoint.x, stairpoint.y, true, parent, child);
						parent.stairGroup.add(stair);

						//This takes care of the ascending staircases
						stairpoint = findStairs(child.map);
						stair = new Stairs(stairpoint.x, stairpoint.y, false, parent, child);
						child.stairGroup.add(stair);
					}
				}
			}
			return;
		}
		*/
		/*
		public function generateEnemies():void
		{
			var width:int = floor.map.widthInTiles;
			var height:int = floor.map.heightInTiles;
			
			var width_by_room:int = width / 18; 
			var height_by_room:int = height / 12; 
			
			for (var i:int = 0; i < width_by_room; i++)
			{
				for (var j:int = 0; j < height_by_room; j++)
				{
					var makeAnEnemy:Boolean = true;
					for each (var stair:Stairs in floor.stairGroup.members)
					{
						if ((i * 900 < stair.x && stair.x < (i + 1) * 900 && j * 600 < stair.y && stair.y < (j + 1) * 600) 
						&& floor.map.getTile(i*18,j*12) != 9)
						{
							 makeAnEnemy = false;
						}
					}
					if (makeAnEnemy)
					{
						if (Math.random() > 0.5)
						{
							var newEnemy:Enemy = new Enemy(i * 900 + 300, j * 600 + 200, "DOC", "BoB", 400);
							add(newEnemy.myName);
							enemyGroup.add(newEnemy);
						}	
						else
						{
							var newEnemy:Enemy = new Enemy(i * 900 + 300, j * 600 + 400, "PDF", "DENNY", 400);
							add(newEnemy.myName);
							enemyGroup.add(newEnemy);
						}	
					}
					
				}
			}
			add(enemyGroup);
		}
		*/
		/*
		//This function will load a map and insert the appropriate stairs
		public function loadMap(floorChange:Floor):void
		{
			remove(this.floor.stairGroup);
			remove(this.floor.map);
			this.floor = floorChange;
			add(floor.map);
			add(floor.stairGroup);
		}
		*/
		//This function will look for stais, designated by the tile 2
		//We know there must be a stair here
		/*
		public function findStairs(floormap:FlxTilemap):FlxPoint
		{
			for (var i:int = 0; i < floormap.widthInTiles; i++)
			{
				for (var j:int = 0; j < floormap.heightInTiles; j++)
				{
					if (floormap.getTile(i, j) == 2)
					{
						floormap.setTile(i, j, 0);
						return new FlxPoint(i * 50, j * 50);
					}
				}
			}
			return new FlxPoint( -1000, -1000);
		}
		*/
	}	
}