level = [
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
];

level2 = [
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
]
# Set to true to enable debug features
debug = true

cursors = null
player = null

LEVEL_TILE_SIZE =
  width: 20
  height: 11

TILE_PIXEL_SIZE =
  width: 64
  height: 64

TILE_LOWERED_OFFSET = 32

Helpers =
  rgbToHex: (r, g, b) ->
    result = 0
    result = (Math.floor(r * 255) & 0xFF) << 16
    result = result | (Math.floor(g * 255) & 0xFF) << 8
    result = result | (Math.floor(b * 255) & 0xFF)
    result

  getZIndex: (x,y) ->
    x + (y * (LEVEL_TILE_SIZE.width + 1))

  logSprite: (sprite) ->
    console.log(sprite.x + "," + sprite.y + "," + sprite.z) if debug


TILE_STATES =
  Depressed: -1
  Normal: 0
  Raised: 1

class LevelTile
  constructor: (x, y, z, blockType) ->
    @startLocation = { x: x * 64, y: y * 64 }
    @defaultz = z
    @mousePressed = false

    @sprite = game.add.sprite(@startLocation.x, @startLocation.y, 'blocks', blockType)
    @sprite.z = z

    @raisedPosition = 0
    @tweenDirection = 0
    @currState = TILE_STATES.Normal
    @prevState = TILE_STATES.Normal
    this.updateBlockDisplay()
    game.physics.arcade.enable(@sprite)
    @sprite.body.immovable = true
    @sprite.body.setSize(64, 30, 0, 34);
    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add () =>
      if debug == true
        newState = @currState + 1
        newState = TILE_STATES.Depressed if newState > 1
        @state(newState)

  updateBlockDisplay: () ->
    @sprite.position = { x: @startLocation.x, y: @startLocation.y + (TILE_LOWERED_OFFSET * (1 - @raisedPosition)) }
    componentDiff = (0xFF - 0xCC) / 0xFF
    component = 1 - (componentDiff * (1 - @raisedPosition))
    @sprite.tint = Helpers.rgbToHex(component, component, component)
  
  update: () ->
    if @prevState != @currState && @tweenDirection != @currState - @prevState
      @tweenDirection = @currState - @prevState
      tween = game.add.tween(this).to({ raisedPosition: @currState }, 1000, Phaser.Easing.Linear.None)
      tween.onComplete.add () =>
        @prevState = @currState
        @tweenDirection = 0
      tween.start()

    @sprite.z = @defaultz
    this.updateBlockDisplay()

  state: (v) ->
    if v?
      @currState = v
      switch @currState
        when TILE_STATES.Depressed then @sprite.body.setSize(64, 10, 0, -30)
        when TILE_STATES.Raised then @sprite.body.setSize(64, 30, 0, 34)

    @currState

allOnOne =
  getTileIndex: (x,y) ->
    x + (y * LEVEL_TILE_SIZE.width)

  getTile: (x,y) ->
    result = @tiles[this.getTileIndex(x,y)]
    result

  createTiles: () ->
    for y in [0...LEVEL_TILE_SIZE.height]
      for x in [0...LEVEL_TILE_SIZE.width]
        type = Math.floor(Math.random() * 5)
        z = Helpers.getZIndex(x, y)
        tile = new LevelTile(x, y, z, type)
        @tiles.push(tile)
        
  updateLevel: (data) ->
    for y in [0...LEVEL_TILE_SIZE.height]
      for x in [0...LEVEL_TILE_SIZE.width]
        tileIndex = this.getTileIndex(x,y)
        tile = @tiles[tileIndex]
        tile.state(data[tileIndex])
    
  preload: () ->
    game.load.spritesheet('blocks', '../content/sprites/blocks.png', 64, 96)
    game.load.spritesheet('player', '../content/sprites/player.png', 64, 64)

  create: () ->
    @tiles = []
    game.physics.startSystem(Phaser.Physics.ARCADE)

    player = game.add.sprite(256, 672, 'player')
    player.animations.add('left', [0, 3, 2, 1], 10, true);
    player.animations.add('right', [4, 5, 6, 7], 10, true);
    game.physics.arcade.enable(player);
    player.body.setSize(40, 64, 10, 0);
    player.body.collideWorldBounds = true;
    cursors = game.input.keyboard.createCursorKeys()
    this.createTiles()
    this.updateLevel(level)
    game.world.bringToTop(player);
    if debug
      debugKey = game.input.keyboard.addKey(Phaser.Keyboard.NUMPAD_0)
      debugKey.onDown.add () =>
        output = []
        for y in [0...LEVEL_TILE_SIZE.height]
          for x in [0...LEVEL_TILE_SIZE.width]
            output.push(@tiles[@getTileIndex(x,y)].state())
        console.log JSON.stringify(output)
      
  update: () ->
    player.z = Helpers.getZIndex(LEVEL_TILE_SIZE.width, Math.floor((player.y + 26) / TILE_PIXEL_SIZE.height)) + 0.5

    for tile in this.tiles
      if tile.state() != TILE_STATES.Normal
        game.physics.arcade.collide(player, tile.sprite)

    if cursors.left.isDown
      player.body.velocity.x = -150
      player.animations.play('left')
    else if cursors.right.isDown
      player.body.velocity.x = 150
      player.animations.play('right')
    else
      player.body.velocity.x = 0
      player.animations.stop()

    if cursors.up.isDown
      player.body.velocity.y = -150
    else if cursors.down.isDown
      player.body.velocity.y = 150
    else
      player.body.velocity.y = 0

    tile.update() for tile in this.tiles

    game.world.sort()

game = new Phaser.Game 1280, 736, Phaser.WEBGL, '', allOnOne
