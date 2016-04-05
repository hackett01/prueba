<?php
require_once __DIR__.'/utility_class.php';

class TheGuardianUtilityClass extends UtilityClass {
        function fetchImage($item) {
		echo "Fetching image from TheGuardian utility class\n";
		
		// We need the 'url'  attribute of the 'media:content' element under this item
		$url = "";
		$media_tags = $item->children('media', TRUE);

		if (count($media_tags) > 0) {
			$url = (string)$media_tags[0]->attributes()->url;
			echo "Fetching {$url}\n";

			list($width, $height, $type, $attr) = getimagesize($url);
                        echo "Size is ".$width."x".$height;

                        if ($width < 400 || $height < 400) return NULL;

			$image_data = file_get_contents($url);
			return $image_data;
		} else {
                	return NULL;
		}
        }
}
