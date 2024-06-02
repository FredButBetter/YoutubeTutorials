extends Sprite3D
class_name ShaderSprite3D

var shaderScriptPath : String = "res://OutlineShader3DWithBonuses.gdshader"
@export var outlineColor := Color.AQUA
@export var outlineLineWeight := 1.0

func _ready() -> void:
	_apply_material_override()
		
	_apply_texture()
	texture_changed.connect(_apply_texture)
	
func _apply_material_override():
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load(shaderScriptPath)
	material_override = shader_material
	shader_material.set_shader_parameter("outlineColor", outlineColor)
	shader_material.set_shader_parameter("lineWeight", outlineLineWeight)

func _apply_texture():
	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter("sprite_texture", texture)

