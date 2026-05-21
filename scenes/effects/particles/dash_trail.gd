class_name DashTrailEffectParticle
extends EffectParticle

func start(direction: float) -> void:
	var mat: ParticleProcessMaterial = process_material.duplicate()
	if direction > 0:
		mat.direction.x = -mat.direction.x
	process_material = mat
	
	super._ready()
