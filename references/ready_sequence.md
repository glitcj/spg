In GDScript, when you add node A (with children B and C) to the scene tree, the initialization order follows a depth-first, top-to-bottom pattern:
Order of Execution

Node A's @onready variables are initialized
Node A's _ready() is called
Node B's @onready variables are initialized
Node B's _ready() is called
Node C's @onready variables are initialized
Node C's _ready() is called

Key Points
The parent's _ready() is called before its children's _ready() methods. This means when A's _ready() executes, B and C are already in the tree but their _ready() methods haven't run yet.
If you need a parent to do something after all its children are ready, you can use the NOTIFICATION_READY notification or connect to the child's ready signal, or wait one frame with await get_tree().process_frame.
This order ensures that:

@onready variables always have access to the scene tree since they execute right before _ready()
Parents can access their children in _ready() (they exist in the tree)
But parents can't rely on children having completed their _ready() logic yet
