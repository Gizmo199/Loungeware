brokens = [
@"if (place_meeting(x + hsp, y, oWall)) {
    while (!place_meeting(x + sign(hsp), y, oWall)) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

if (place_meeting(x, y + vsp, oWall)) {
    while (!place_meeting(x, y + sign(vsp), oWall)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;",
]

for (var i = 0; i < array_length(brokens); i++) {
	var yy = 0;
	var j = 0;
	var broken = brokens[i];
	var temp = [];
	
	for (var __j = 1; __j < string_length(broken); { __j++; j++ }) {
		var char = string_char_at(broken, __j);
		
		if (char == "\n") {
			temp[yy][j] = " ";
			yy++;
			j = -1;
			continue;
		}
		temp[yy][j] = char;
	}
	
	brokens[i] = temp;
	
	//fill rest with space characters
	//var max_len = 0;
	//var broken = brokens[i];
	//for (var j = 0; j < array_length(broken); j++) {
	//	if (array_length(broken[j]) > max_len) {
	//		max_len = array_length(broken[j]);
	//	}	
	//}
	//for (var j = 0; j < array_length(broken); j++) {
	//	//line
	//	for (var k = 0; k < max_len; k++) {
	//		//char
	//		broken[j][k] = k > (array_length(broken[j]) - 1) ? " " : broken[j][k];
	//	}
	//}
}

broken_code = brokens[0];
draw_set_text(c_white, tfg_collision_fnt_jetbrains, fa_left, fa_top);
line_cols = function(_y) {
	if (_y > array_length(broken_code) - 1) 
		return array_length(broken_code[array_length(broken_code) - 1]);
	if (_y < 0)
		return array_length(broken_code[0]);
	return array_length(broken_code[_y]);
}
rows = array_length(broken_code);

cursor = {
	x: 0,
	y: 0,
	w: 2,
	flash_delay: 30,
	t: 0,
	drawing: true,
	buffer_time: 20,
	spd_when_held: 2, //1 unit every 2 frames
	spd_when_held_t: 0,
}

any_dir_key = function() {
	return KEY_RIGHT || KEY_LEFT || KEY_UP || KEY_DOWN;
}

time_held = {
	left: 0, right: 0, up: 0, down: 0,	
}
update_time_held = function() {
	struct_foreach(time_held, function(_item) {
		time_held[$ _item]++;
	});
	
	if (!KEY_RIGHT)	time_held.right = 0;
	if (!KEY_LEFT) time_held.left = 0;
	if (!KEY_UP) time_held.up = 0;
	if (!KEY_DOWN) time_held.down = 0;
}

function EditMenuOption(_name, _callback) constructor {
	callback = _callback;
	name = _name;
}
edit_menu = [
	new EditMenuOption("Backspace", function() {
		if (cursor.x <= 0) exit;
		array_delete(broken_code[cursor.y], --cursor.x, 1);
	}),
	new EditMenuOption("+ hsp", function() {
		array_foreach(array_reverse(["+", " ", "h", "s", "p"]), function(_char) {
			array_insert(broken_code[cursor.y], cursor.x, _char);
		});
	}),
];
edit_menu_w = 0;
edit_menu_x_pad = 20;
edit_menu_y_pad = 10;
draw_set_font(tfg_collision_fnt_frogtype);
for (var i = 0; i < array_length(edit_menu); i++) { 
	edit_menu_w += string_width(edit_menu[i].name) + edit_menu_x_pad * 2; 
}
edit_menu_h = string_height("M") + edit_menu_y_pad * 2;
is_edit_menu_draw = false;
edit_menu_select = 0;

toggle_edit_menu = function() {
	is_edit_menu_draw = !is_edit_menu_draw;
	edit_menu_select = 0;
}


