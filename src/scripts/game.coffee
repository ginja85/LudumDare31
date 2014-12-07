levels = [
  {
    data: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1,
      1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
      1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1,-1, 1, 1, 1, 0, 1,
      1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1,
      1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1,
      1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,-1, 0, 1, 0, 0, 0, 0, 0, 1,
      1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1,-1, 1, 1, 1, 0, 1,
      1, 0, 0, 0, 0, 0, 0, 1, 0, 1,-1, 1, 0, 0, 0, 1, 0, 0, 0, 1,
      1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1,
      1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    ]
    start: (state) ->
      state.monsterEntities.push(new Monster(16, 5, 'slime', 20, 5))
      state.player.sprite.body.collideWorldBounds = false
      state.chest.sprite.position = Helpers.getEntityPositionForTile(17, 8)
      state.player.sprite.position = Helpers.getEntityPositionForTile(4, 13)
      state.player.forceMove(new ForceMoveDirectionUp(256, () ->
        state.player.inputActive = false
        state.getTile(4, 10).state(TILE_STATES.Raised)
        next = -> state.player.forceMove(new ForceMoveDirectionDown(0, -> state.player.sprite.body.collideWorldBounds = true))
        setTimeout(next, 1250)))
    cleanup: null
  }, {
    data: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1,
      1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1,
      1, 0, 0, 0,-1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1,
      1, 1, 0, 1,-1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1,
      1, 0, 0, 0, 0, 0,-1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1,-1, 1, 1,
      1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,-1, 0, 0, 0, 0, 1,
      1,-1, 0, 0, 0, 0, 0,-1, 0, 0, 0, 1, 0, 0,-1, 0, 1, 1, 1, 1,
      1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1,
      1, 0, 0, 0,-1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    ]
    start: (state) ->
      state.chest.sprite.position = Helpers.getEntityPositionForTile(2, 2)
    cleanup: null
  }
]
# Set to true to enable debug features
debug = true

cursors = null
wasd = null
slime = null
shakeWorld = 0

PI = Math.PI
QUARTER_PI = PI * 0.25
HALF_PI = PI * 0.5
THREE_QUARTER_PI = PI * 0.75

LEVEL_TILE_SIZE =
  width: 20
  height: 11

TILE_PIXEL_SIZE =
  width: 64
  height: 64

TILE_LOWERED_OFFSET = 32

TILE_STATES =
  Depressed: -1
  Normal: 0
  Raised: 1

SHADOW_COLOR =
  from: 0x55
  to: 0xFF

BLOCK_TYPES = 4

DIRECTION =
  up: 0
  down: 1
  left: 2
  right: 3
  none: 4

Helpers =
  getEntityPositionForTile: (tileX, tileY) ->
      x: tileX * TILE_PIXEL_SIZE.width
      y: tileY * TILE_PIXEL_SIZE.height + TILE_LOWERED_OFFSET
    
  rgbToHex: (r, g, b) ->
    result = 0
    result = (Math.floor(r * 255) & 0xFF) << 16
    result = result | (Math.floor(g * 255) & 0xFF) << 8
    result = result | (Math.floor(b * 255) & 0xFF)
    result

  getTileIndex: (x,y) ->
    x + (y * LEVEL_TILE_SIZE.width)
    
  getZIndex: (x,y) ->
    x + (y * (LEVEL_TILE_SIZE.width + 1))

  logSprite: (sprite) ->
    console.log(sprite.x + "," + sprite.y + "," + sprite.z) if debug

  levelDataToString: (tiles) ->
    result = "["
    for y in [0...LEVEL_TILE_SIZE.height]
      result += "\n  "
      for x in [0...LEVEL_TILE_SIZE.width]
        state = tiles[Helpers.getTileIndex(x, y)].state()
        v = " "
        v = "" if state == -1
        result += v + state + ","
    result.substr(0, result.length - 1) + "]"

  chainCallback: (o, n) ->
    () ->
      n?.apply(null, arguments)
      o?.apply(null, arguments)

  getDirectionFromAngle: (angle) ->
    if angle >= -QUARTER_PI && angle < QUARTER_PI
      DIRECTION.right
    else if (angle >= THREE_QUARTER_PI && angle <= PI) || (angle >= -PI && angle < -THREE_QUARTER_PI)
      DIRECTION.left
    else if angle >= QUARTER_PI && angle < THREE_QUARTER_PI
      DIRECTION.down
    else
      DIRECTION.up


class KeymapEntry
  constructor: () ->
    @keys = []

  add: (key) ->
    @keys.push(key)

  isDown: () ->
    for key in @keys
      return true if key.isDown
    false

keymap =
  up: new KeymapEntry(),
  down: new KeymapEntry(),
  left: new KeymapEntry(),
  right: new KeymapEntry()


class ForceMoveDirection
  constructor: (amount, callback) ->
    @amount = amount
    @callback = callback

  move: () ->
    if @hasFinished()
      @callback?()

  assignMoveable: (moveable) ->
    @moveable = moveable
    @onMoveableAssigned?()

  hasFinished: 
    true

class ForceKnockbackMove extends ForceMoveDirection
  constructor: (amount, direction, callback) ->
    @direction = direction
    super(amount, callback)

  onMoveableAssigned: () ->
    @start = game.time.now

  move: () ->
    switch @direction
      when DIRECTION.left
        @moveable.sprite.body.velocity.x = -@amount
      when DIRECTION.right
        @moveable.sprite.body.velocity.x = @amount
      when DIRECTION.up
        @moveable.sprite.body.velocity.y = -@amount
      when DIRECTION.down
        @moveable.sprite.body.velocity.y = @amount

    super()

  hasFinished: () ->
    game.time.now > @start + 250

class ForceMoveDirectionUp extends ForceMoveDirection
  constructor: (amount, callback) ->
    super(amount, callback)

  onMoveableAssigned: () ->
    @start = @moveable.sprite.y
    
  move: () ->
    @moveable.move(DIRECTION.up)
    super()
    
  hasFinished: () ->
    @moveable.sprite.y < @start - @amount
 
class ForceMoveDirectionDown extends ForceMoveDirection
  constructor: (amount, callback) ->
    super(amount, callback)

  onMoveableAssigned: () ->
    @start = @moveable.sprite.y

  move: () ->
    @moveable.move(DIRECTION.down)
    super()
    
  hasFinished: () ->
    @moveable.sprite.y > @start + @amount

class ForceMoveDirectionLeft extends ForceMoveDirection
  constructor: (amount, callback) ->
    super(amount, callback)

  onMoveableAssigned: () ->
    @start = @moveable.sprite.x

  move: () ->
    @moveable.move(DIRECTION.left)
    super()
    
  hasFinished: () ->
    @moveable.sprite.x < @start - @amount

class ForceMoveDirectionRight extends ForceMoveDirection
  constructor: (amount, callback) ->
    super(amount, callback)

  onMoveableAssigned: () ->
    @start = @moveable.sprite.x

  move: () ->
    @moveable.move(DIRECTION.right)
    super()
    
  hasFinished: () ->
    @moveable.sprite.x > @start + @amount

# LevelTile represents a single tile in the level
class LevelTile
  constructor: (x, y, z, blockType) ->
    @blockType = blockType
    @startLocation = { x: x * 64, y: y * 64 }
    @defaultz = z
    @mousePressed = false

    @raisedPosition = 0
    @tweenDirection = 0
    @currState = TILE_STATES.Normal
    @prevState = TILE_STATES.Normal
    
    @createSprite()

    @updateBlockDisplay()

    
  createSprite: () ->
    @sprite = game.add.sprite(@startLocation.x, @startLocation.y, 'blocks', @blockType)
    game.physics.arcade.enable(@sprite)
    @sprite.z = @defaultz
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
    componentDiff = (SHADOW_COLOR.to - SHADOW_COLOR.from) / 0xFF
    raisedState = (@raisedPosition + 1) / 2
    component = 1 - (componentDiff * (1 - raisedState))
    @sprite.tint = Helpers.rgbToHex(component, component, component)

  expectedStateDirection: () ->
    @currState - @prevState
    
  hasStateChanged: () ->
    @prevState != @currState && @tweenDirection != @expectedStateDirection()

  commitState: () ->
    @prevState = @currState
    @tweenDirection = 0
    shakeWorld = 0

  onStateChanged: () ->
    @tweenDirection = @expectedStateDirection()
    tween = game.add.tween(this).to({ raisedPosition: @currState }, 1000, Phaser.Easing.Linear.None)
    tween.onComplete.add () => @commitState()
    tween.start()
    
  update: () ->
    if @hasStateChanged()
      @onStateChanged()
      
    @sprite.z = @defaultz
    @updateBlockDisplay()

  state: (v) ->
    if v?
      @currState = v
      switch @currState
        when TILE_STATES.Depressed then @sprite.body.setSize(64, 10, 0, -30)
        when TILE_STATES.Raised then @sprite.body.setSize(64, 30, 0, 34)

    @currState

class Moveable
  move: (direction) ->
    switch direction
      when DIRECTION.up then @onMoveUp?()
      when DIRECTION.down then @onMoveDown?()
      when DIRECTION.left then @onMoveLeft?()
      when DIRECTION.right then @onMoveRight?()
      when DIRECTION.none then @onMoveStop?()

  forceMove: (m) ->
    @activeForceMove = m
    m.assignMoveable(this)
    @activeForceMove.callback = Helpers.chainCallback(@activeForceMove.callback, () =>
      @move(DIRECTION.none)
      @activeForceMove = null)
      

  update: () ->
    @activeForceMove.move() if @activeForceMove?

# Player is the player object
class Player extends Moveable

  MOVEMENT_SPEED: 150
  
  constructor: () ->
    @health = 100

    @inputActive = true
    
    @sprite = game.add.sprite(256, 640, 'player')
    @sprite.animations.add('left', [0, 3, 0, 1], 7, true)
    @sprite.animations.add('right', [4, 5, 4, 7], 7, true)
    @sprite.animations.add('down', [8, 9, 10, 11], 7, true)
    @sprite.animations.add('up', [12, 13, 14, 15], 7, true)

    game.physics.arcade.enable(@sprite)
    @sprite.body.setSize(40, 64, 10, 0)
    @activeForceMove = null
    @sprite.body.collideWorldBounds = true

  onMoveUp: () ->
    @sprite.body.velocity.y = -@MOVEMENT_SPEED
    @sprite.animations.play('up')

  onMoveDown: () ->
    @sprite.body.velocity.y = @MOVEMENT_SPEED
    @sprite.animations.play('down')

  onMoveLeft: () ->
    @sprite.body.velocity.x = -@MOVEMENT_SPEED
    @sprite.animations.play('left')

  onMoveRight: () ->
    @sprite.body.velocity.x = @MOVEMENT_SPEED
    @sprite.animations.play('right')

  onMoveStop: () ->
    @sprite.body.velocity.x = 0
    @sprite.body.velocity.y = 0
    @sprite.animations.stop()


  handleInput: () ->
    if keymap.left.isDown()
      @move(DIRECTION.left)
    else if keymap.right.isDown()
      @move(DIRECTION.right)
    else
      @sprite.body.velocity.x = 0

    if keymap.up.isDown()
      @move(DIRECTION.up)
    else if keymap.down.isDown()
      @move(DIRECTION.down)
    else
      @sprite.body.velocity.y = 0

  forceMove: (f) ->
    @inputActive = false    
    f.callback = Helpers.chainCallback(f.callback, () => @inputActive = true)
    super(f)
    
  update: () ->
    super()

    @sprite.z = Helpers.getZIndex(LEVEL_TILE_SIZE.width, Math.floor((@sprite.y + 26) / TILE_PIXEL_SIZE.height)) + 0.5

    @handleInput() if @inputActive

    if @sprite.body.velocity.x == 0 && @sprite.body.velocity.y == 0
      @sprite.animations.stop()

  takeDamage: (source) ->
    unless @activeForceMove?
      direction = Helpers.getDirectionFromAngle(Phaser.Math.angleBetweenPoints(source.sprite.position, @sprite.position))
      @forceMove(new ForceKnockbackMove(300, direction, () -> {}))
      @health = @health - source.damage

class Chest
  constructor: () ->
    @sprite = game.add.sprite(640, 192, 'chest')
    game.physics.arcade.enable(@sprite);
    @sprite.body.setSize(45, 5, 20, 30);
    @sprite.body.immovable = true    

  update: () ->
    @sprite.z = Helpers.getZIndex(LEVEL_TILE_SIZE.width, Math.floor((@sprite.y + 26) / TILE_PIXEL_SIZE.height)) + 0.1

class Monster
  constructor: (x, y, type, health, damage) ->
    @health = health
    @damage = damage

    @sprite = game.add.sprite(0, 0, type)
    @sprite.position = Helpers.getEntityPositionForTile(x, y)
    @sprite.animations.add('idle', [0, 1, 2, 3, 4, 5, 6, 7], 7, true)

    game.physics.arcade.enable(@sprite)
    @sprite.body.setSize(40, 64, 10, 0)
    @sprite.body.immovable = true

  update: () ->
    @sprite.z = Helpers.getZIndex(LEVEL_TILE_SIZE.width, Math.floor((@sprite.y + 26) / TILE_PIXEL_SIZE.height)) + 0.1
    @sprite.animations.play('idle')

  takeDamage: (dmg) ->
    @health = @health - dmg

class SpiderThief
  constructor: () ->
    @sprite = game.add.sprite(-100, -100, 'spiderThief')

  update: () ->
      
# Default game state
allOnOne =
  getTileIndex: (x,y) ->
    x + (y * LEVEL_TILE_SIZE.width)

  getTile: (x,y) ->
    @tiles[@getTileIndex(x,y)]
    
  createTiles: () ->
    for y in [0...LEVEL_TILE_SIZE.height]
      for x in [0...LEVEL_TILE_SIZE.width]
        type = Math.floor(Math.random() * BLOCK_TYPES)
        z = Helpers.getZIndex(x, y)
        tile = new LevelTile(x, y, z, type)
        @tiles.push(tile)
        @entities.push(tile)
        
  updateLevel: (level) ->
    for monster in @monsterEntities
        monster.sprite.kill()

    @level?.cleanup?(this)
    @level = level
    shakeWorld = 1
    for y in [0...LEVEL_TILE_SIZE.height]
      for x in [0...LEVEL_TILE_SIZE.width]
        tileIndex = @getTileIndex(x,y)
        tile = @getTile(x,y)# @tiles[tileIndex]
        tile.state(level.data[tileIndex])

    @level?.start?(this)

  nextLevel: () ->
    @currentLevel++ if @currentLevel?
    @currentLevel = 0 unless @currentLevel?

    @updateLevel(levels[@currentLevel])

  levelTransition: () ->
    return if @transitioning
    @transitioning = true
    @nextLevel()
    @transitioning = false
    
  preload: () ->
    game.time.advancedTiming = true
    game.load.spritesheet('blocks', '../content/sprites/blocks.png', 64, 128)
    game.load.spritesheet('player', '../content/sprites/player.png', 64, 64)
    game.load.image('chest', '../content/sprites/chest.png')
    game.load.spritesheet('slime', '../content/sprites/slime.png', 64, 64)

  setupKeyboard: () ->
    addToKeyMap = (maps) ->
      for mapKey, key of maps
        keymap[mapKey].add(key) if keymap[mapKey]?

    addToKeyMap(game.input.keyboard.createCursorKeys())
    addToKeyMap(
      up: game.input.keyboard.addKey(Phaser.Keyboard.W)
      down: game.input.keyboard.addKey(Phaser.Keyboard.S)
      left: game.input.keyboard.addKey(Phaser.Keyboard.A)
      right: game.input.keyboard.addKey(Phaser.Keyboard.D))

  create: () ->
    @tiles = []
    @entities = []
    @criticalEntities = []
    @monsterEntities = []

    game.physics.startSystem(Phaser.Physics.ARCADE)
    @setupKeyboard()

    @createTiles()
    @player = new Player()
    @chest = new Chest()
    @criticalEntities.push(@player)
    @criticalEntities.push(@chest)
    @nextLevel()

    if debug
      debugKey = game.input.keyboard.addKey(Phaser.Keyboard.TILDE)
      debugKey.onDown.add () =>
        console.log(Helpers.levelDataToString(@tiles))
        
  update: () ->
    for entity in @criticalEntities
      entity.update?()

    for entity in @monsterEntities
      entity.update?()
    
    # Perform updates
    for entity in @entities
      entity.update?()
      
    # Do collision checks
    for tile in @tiles
      if tile.state() != TILE_STATES.Normal
        game.physics.arcade.collide(@player.sprite, tile.sprite)
        for monster in @monsterEntities
          game.physics.arcade.collide(monster.sprite, tile.sprite)

    for monster in @monsterEntities
      game.physics.arcade.collide(
        @player.sprite, monster.sprite, () => @player.takeDamage(monster))

    game.physics.arcade.collide(@player.sprite, @chest.sprite, () => @levelTransition())

    #if shakeWorld > 0
    #  @rand1 = game.rnd.integerInRange(-20,20)
    #  @rand2 = game.rnd.integerInRange(-20,20)
    #  game.world.setBounds(@rand1, @rand2, game.width + @rand1, game.height + @rand2)

    #if shakeWorld == 0
    #  game.world.setBounds(0, 0, game.width, game.height)

    # Sort sprites and groups in the world, so that z-order is correct
    game.world.sort()

  render: () ->
    game.debug.text(game.time.fps || '--', 2, 14, "#00ff00");
#    game.debug.renderInputInfo(16, 16)

game = new Phaser.Game 1280, 736, Phaser.WEBGL, '', allOnOne
