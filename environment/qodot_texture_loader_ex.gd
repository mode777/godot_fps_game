class_name QodotTextureLoaderEx
extends QodotTextureLoader

var enable_compression: bool = true

func load_texture(texture_name: String) -> Texture2D:
	var tex = super(texture_name)
	if tex != null:
		return tex
		
	for texture_extension in texture_extensions:
		var texture_path := "%s/%s.%s" % [base_texture_path, texture_name, texture_extension]
		if FileAccess.file_exists(texture_path):
			tex = load_texture_from_file(texture_path)
			return tex
		
	print("Texture not found %s/%s.*" % [base_texture_path, texture_name])
	return tex
	
func load_texture_from_file(path: String, hint: Image.CompressSource = Image.COMPRESS_SOURCE_GENERIC):
	var img = Image.load_from_file(path)
	img.generate_mipmaps(hint == Image.COMPRESS_SOURCE_NORMAL)
	if OS.has_feature("editor") and enable_compression:
		img.compress(Image.COMPRESS_S3TC, hint)
	elif enable_compression:
		print("WARNING: '%s' texture compression unavailable" % path)
	var tex = ImageTexture.create_from_image(img)
	return tex
	
func get_pbr_texture(texture: String, suffix: PBRSuffix) -> Texture2D:
	var texture_comps : PackedStringArray = texture.split('/')

	if texture_comps.size() == 0:
		return null

	for texture_extension in texture_extensions:
		var path := "%s/%s/%s" % [
			base_texture_path,
			'/'.join(texture_comps),
			get_pbr_suffix_pattern(suffix) % [
				texture_comps[-1],
				texture_extension
			]
		]
		
		if(FileAccess.file_exists(path)):
			if ResourceLoader.exists(path):
				return load(path) as Texture2D
			elif FileAccess.file_exists(path):
				return load_texture_from_file(path, Image.COMPRESS_SOURCE_NORMAL if suffix == PBRSuffix.NORMAL else Image.COMPRESS_SOURCE_GENERIC)

	return null
