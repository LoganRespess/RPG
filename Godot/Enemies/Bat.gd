extends KinematicBody2D
const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

var knockBack = Vector2.ZERO
onready var Stats = $Stats

func _physics_process(delta):
	knockBack = move_and_slide(knockBack)
	knockBack = knockBack.move_toward(Vector2.ZERO, 200 * delta)

func _on_Hurtbox_area_entered(area):
	knockBack = area.knockBack_vector * 125
	Stats.health -= area.damage
	


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
