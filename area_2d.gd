extends Area2D

var rng = RandomNumberGenerator.new()



func _on_body_entered(body):
	var rng_damage = rng.randi_range(1, 3)
	var damage_total = 0
	if body.name == "Zombie":
		print(rng_damage, " DMG dealt!")	
	#damage_total = damage_total + rng_damage
	#print("damage total:", damage_total)
