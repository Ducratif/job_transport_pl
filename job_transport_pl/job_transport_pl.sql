-- Ajouter le job "chauffeurpl"
INSERT INTO `jobs` (`name`, `label`, `whitelisted`, `useSystem`) VALUES
('chauffeurpl', 'Chauffeur PL', 1, 0);

-- Ajouter les grades du job "chauffeurpl"
INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('chauffeurpl', 0, 'stagiaire', 'Stagiaire', 500, 
'{"tshirt_2":0,"hair_color_1":5,"glasses_2":3,"shoes":9,"torso_2":3,"hair_color_2":0,"pants_1":24,"glasses_1":4,"hair_1":2,"sex":0,"decals_2":0,"tshirt_1":15,"helmet_1":8,"helmet_2":0,"arms":92,"face":19,"decals_1":60,"torso_1":13,"hair_2":0,"skin":34,"pants_2":5}',
'{"tshirt_2":3,"decals_2":0,"glasses":0,"hair_1":2,"torso_1":73,"shoes":1,"hair_color_2":0,"glasses_1":19,"skin":13,"face":6,"pants_2":5,"tshirt_1":75,"pants_1":37,"helmet_1":57,"torso_2":0,"arms":14,"sex":1,"glasses_2":0,"decals_1":0,"hair_2":0,"helmet_2":0,"hair_color_1":0}'),

('chauffeurpl', 1, 'apprenti', 'Apprenti Chauffeur PL', 700, 
'{"tshirt_2":1,"hair_color_1":2,"glasses_2":1,"shoes":10,"torso_2":5,"hair_color_2":1,"pants_1":26,"glasses_1":5,"hair_1":3,"sex":0,"decals_2":1,"tshirt_1":16,"helmet_1":10,"helmet_2":1,"arms":95,"face":20,"decals_1":62,"torso_1":18,"hair_2":1,"skin":35,"pants_2":6}',
'{"tshirt_2":2,"decals_2":1,"glasses":1,"hair_1":3,"torso_1":74,"shoes":2,"hair_color_2":1,"glasses_1":20,"skin":14,"face":7,"pants_2":6,"tshirt_1":76,"pants_1":38,"helmet_1":58,"torso_2":1,"arms":15,"sex":1,"glasses_2":1,"decals_1":1,"hair_2":1,"helmet_2":1,"hair_color_1":1}'),

('chauffeurpl', 2, 'chauffeur_pl', 'Chauffeur PL', 900, 
'{"tshirt_2":2,"hair_color_1":3,"glasses_2":2,"shoes":11,"torso_2":6,"hair_color_2":2,"pants_1":28,"glasses_1":6,"hair_1":4,"sex":0,"decals_2":2,"tshirt_1":17,"helmet_1":11,"helmet_2":2,"arms":98,"face":21,"decals_1":64,"torso_1":20,"hair_2":2,"skin":36,"pants_2":7}',
'{"tshirt_2":3,"decals_2":2,"glasses":2,"hair_1":4,"torso_1":75,"shoes":3,"hair_color_2":2,"glasses_1":21,"skin":15,"face":8,"pants_2":7,"tshirt_1":77,"pants_1":39,"helmet_1":59,"torso_2":2,"arms":16,"sex":1,"glasses_2":2,"decals_1":2,"hair_2":2,"helmet_2":2,"hair_color_1":2}'),

('chauffeurpl', 3, 'chauffeur_pl_exp', 'Chauffeur PL Expérimenté', 1200, 
'{"tshirt_2":3,"hair_color_1":4,"glasses_2":3,"shoes":12,"torso_2":7,"hair_color_2":3,"pants_1":30,"glasses_1":7,"hair_1":5,"sex":0,"decals_2":3,"tshirt_1":18,"helmet_1":12,"helmet_2":3,"arms":100,"face":22,"decals_1":66,"torso_1":22,"hair_2":3,"skin":37,"pants_2":8}',
'{"tshirt_2":4,"decals_2":3,"glasses":3,"hair_1":5,"torso_1":76,"shoes":4,"hair_color_2":3,"glasses_1":22,"skin":16,"face":9,"pants_2":8,"tshirt_1":78,"pants_1":40,"helmet_1":60,"torso_2":3,"arms":17,"sex":1,"glasses_2":3,"decals_1":3,"hair_2":3,"helmet_2":3,"hair_color_1":3}'),

('chauffeurpl', 4, 'chef_equipe', 'Chef d\'équipe', 1500, 
'{"tshirt_2":4,"hair_color_1":5,"glasses_2":4,"shoes":13,"torso_2":8,"hair_color_2":4,"pants_1":32,"glasses_1":8,"hair_1":6,"sex":0,"decals_2":4,"tshirt_1":19,"helmet_1":13,"helmet_2":4,"arms":102,"face":23,"decals_1":68,"torso_1":24,"hair_2":4,"skin":38,"pants_2":9}',
'{"tshirt_2":5,"decals_2":4,"glasses":4,"hair_1":6,"torso_1":77,"shoes":5,"hair_color_2":4,"glasses_1":23,"skin":17,"face":10,"pants_2":9,"tshirt_1":79,"pants_1":41,"helmet_1":61,"torso_2":4,"arms":18,"sex":1,"glasses_2":4,"decals_1":4,"hair_2":4,"helmet_2":4,"hair_color_1":4}'),

('chauffeurpl', 5, 'patron', 'Patron', 2000, 
'{"tshirt_2":5,"hair_color_1":6,"glasses_2":5,"shoes":14,"torso_2":9,"hair_color_2":5,"pants_1":34,"glasses_1":9,"hair_1":7,"sex":0,"decals_2":5,"tshirt_1":20,"helmet_1":14,"helmet_2":5,"arms":104,"face":24,"decals_1":70,"torso_1":26,"hair_2":5,"skin":39,"pants_2":10}',
'{"tshirt_2":6,"decals_2":5,"glasses":5,"hair_1":7,"torso_1":78,"shoes":6,"hair_color_2":5,"glasses_1":24,"skin":18,"face":11,"pants_2":10,"tshirt_1":80,"pants_1":42,"helmet_1":62,"torso_2":5,"arms":19,"sex":1,"glasses_2":5,"decals_1":5,"hair_2":5,"helmet_2":5,"hair_color_1":5}');
