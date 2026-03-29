extends VBoxContainer

class_name VolumeControls

@onready var master_slider = $MasterRow/MasterSlider
@onready var master_value = $MasterRow/MasterValue



func _ready() -> void:
	master_slider.value = GameSettings.master_volume
	master_value.text = str(int(GameSettings.master_volume * 100)) + "%"
	master_slider.value_changed.connect(on_master_changed)



func on_master_changed(value: float) -> void:
	GameSettings.master_volume = value
	master_value.text = str(int(value * 100)) + "%"
	GameSettings.apply_volumes()
	GameSettings.save_settings()



func refresh() -> void:
	master_slider.value = GameSettings.master_volume
	master_value.text = str(int(GameSettings.master_volume * 100)) + "%"
