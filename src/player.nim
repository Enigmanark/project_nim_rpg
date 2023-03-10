import nimraylib_now
import sprite_animated

type Player* = ref object of AnimatedSprite
    moveTimer : float
    moveDelay : float
    canMove : bool
    tryingToMove* : bool
    moveToPosition* : Vector2

proc NewPlayer*(path : string, x : float, y : float) : Player =
    let sprite = NewAnimatedSprite(path, x, y)
    var player = Player()
    player.srcRect = sprite.srcRect
    player.position = sprite.position
    player.texture = sprite.texture
    player.animDelay = sprite.animDelay
    player.moveTimer = 0f
    player.moveDelay = 0.15
    player.canMove = true
    player.tryingToMove = false
    player.moveToPosition = Vector2()

    return player

proc ApplyMove*(self : Player, can : bool) =
    if can:
        self.tryingToMove = false
        self.canMove = false
        self.position = self.moveToPosition
        self.moveToPosition = Vector2()
    else:
        self.tryingToMove = false
        self.canMove = true
        self.moveToPosition = Vector2()

proc Move(self : Player, dir : Vector2, delta : float) =
    if self.canMove:
        if dir.y == -1:
            self.moveToPosition.y = self.position.y - 16
            self.moveToPosition.x = self.position.x
        elif dir.y == 1:
            self.moveToPosition.y = self.position.y + 16
            self.moveToPosition.x = self.position.x
        elif dir.x == -1:
            self.moveToPosition.y = self.position.y
            self.moveToPosition.x = self.position.x - 16
        elif dir.x == 1:
            self.moveToPosition.y = self.position.y
            self.moveToPosition.x = self.position.x + 16

        if dir.x != 0 or dir.y != 0:
            self.tryingToMove = true
    else:
        self.moveTimer += delta
        if self.moveTimer >= self.moveDelay:
            self.moveTimer = 0f
            self.canMove = true

method Update*(self : Player, delta : float) =
    self.animTimer += delta
    if self.animTimer >= self.animDelay:
        self.animTimer = 0f
        if self.srcRect.x == 0:
            self.srcRect.x = 16
        else:
            self.srcRect.x = 0

    var dir = Vector2()
    if isKeyDown(KeyboardKey.W) or isKeyPressed(KeyBoardKey.W):
        dir.y = -1
    elif isKeyDown(KeyboardKey.S) or isKeyPressed(KeyBoardKey.S):
        dir.y = 1
    elif isKeyDown(KeyboardKey.A) or isKeyPressed(KeyBoardKey.A):
        dir.x = -1
    elif isKeyDown(KeyboardKey.D) or isKeyPressed(KeyBoardKey.D):
        dir.x = 1

    self.Move(dir, delta)
