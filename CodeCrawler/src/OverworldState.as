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
		
		private var fib:RoomLayout;
		
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
			
			fib = new RoomLayout("fact");
			fib.addParam("x");
			
			var c:Constant = new Constant("int", 5, 1 * TILEWIDTH, 1 * TILEHEIGHT);
			room_layout_list.addItem(fib);
			current_room = (RoomLayout)(room_layout_list.getItemAt(0)).generateRoom(c, null);
			current_room.loadMap(new map_data, Floor_Tiles, TILEWIDTH, TILEHEIGHT);	
			current_room.instantiateTemplateItem(new Door(fib,-1, -1));
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
			var considered_item:Item;
			if (player.x < 0) {
				/*copy this code into all of the other checks for each door*/
				for (i = 0; i < current_room.items.length; i++)
				{
					considered_item = current_room.items.getItemAt(i) as Item;
					if (considered_item is Door)
					{
						var considered_door:Door = (Door)(current_room.items.getItemAt(i));
						if (considered_door.associated_wall == Room.LEFT) 
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
								current_room = considered_door.linked_room;
								break;
							}
						}
					}
				}
				player.x = 800 - 2 * TILEWIDTH;
				instantiateRoom(current_room);
				return;
			}
			else if (player.x > 800 - player.height) {
				/*copy this code into all of the other checks for each door*/
				for (i = 0; i < current_room.items.length; i++)
				{
					considered_item = current_room.items.getItemAt(i) as Item;
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
								current_room = considered_door.linked_room;
								break;
							}
						}
					}
				}
				player.x = 0 + TILEWIDTH;
				instantiateRoom(current_room);
				return;
			}
			else if (player.y < 0) {
				/*copy this code into all of the other checks for each door*/
				for (i = 0; i < current_room.items.length; i++)
				{
					considered_item = current_room.items.getItemAt(i) as Item;
					if (considered_item is Door)
					{
						var considered_door:Door = (Door)(current_room.items.getItemAt(i));
						if (considered_door.associated_wall == Room.TOP) 
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
								current_room = considered_door.linked_room;
								break;
							}
						}
					}
				}
				player.y = 600 - 2 * TILEHEIGHT;
				instantiateRoom(current_room);
				return;
			}
			else if (player.y > 600 - player.height) {
				/*copy this code into all of the other checks for each door*/
				for (i = 0; i < current_room.items.length; i++)
				{
					considered_item = current_room.items.getItemAt(i) as Item;
					if (considered_item is Door)
					{
						var considered_door:Door = (Door)(current_room.items.getItemAt(i));
						if (considered_door.associated_wall == Room.BOTTOM) 
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
								current_room = considered_door.linked_room;
								break;
							}
						}
					}
				}
				player.y = 0 + TILEHEIGHT;
				instantiateRoom(current_room);
				return;
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
			for (i = 0; i < current_room.items.length; i++)
			{
				considered_item = (Item)(current_room.items.getItemAt(i));
				if (!(considered_item is Door))
				{
					if (considered_item != null && player.overlaps(considered_item)) {
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
		
		public function instantiateRoom(current_room:Room):void
		{
			current_room.loadMap(new map_data, Floor_Tiles, TILEWIDTH, TILEHEIGHT);	
			add(current_room);
			
			for (var i:int = 0; i < current_room.items.length; i++)
			{
				add((Item)(current_room.items.getItemAt(i)));
			}
		}
	}	
}