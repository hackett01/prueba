<?php

require 'vendor/autoload.php';
require 'config/config.php';

require 'util/theguardian.php';
require 'util/vice.php';

use Parse\ParseObject;
use Parse\ParseQuery;
use Parse\ParseACL;
use Parse\ParsePush;
use Parse\ParseUser;
use Parse\ParseInstallation;
use Parse\ParseException;
use Parse\ParseAnalytics;
use Parse\ParseFile;
use Parse\ParseCloud;
use Parse\ParseClient;

ParseClient::initialize( $app_id, $rest_key, $master_key );

// Set individual access rights
$acl = new ParseACL();
$acl->setPublicReadAccess(true);
$acl->setPublicWriteAccess(true);

/*
$object = ParseObject::create("TestObject");
$objectId = $object->getObjectId();
$php = $object->get("elephant");

// Set values:
$object->set("elephant", "php");
$object->set("today", new DateTime());
$object->setArray("mylist", [1, 2, 3]);
$object->setAssociativeArray(
    "languageTypes", array("php" => "awesome", "ruby" => "wtf")
);

// Save:
$object->save();
*/

// Fetch the list of feeds
$query = new ParseQuery("Feed");

$query->each(function($obj) {
    $url = $obj->url;
    $source = $obj->source;
    $utility_class = $obj->utilityClass;

    echo $source."\n";
    echo "========================\n";
    echo "Fetching ".$url."\n";

    $feedItems = simplexml_load_file($url);

    $items = $feedItems->channel->item;

    foreach($items as $i => $item) {

        $title = (string) $item->title[0];
        $guid = (string) $item->guid[0];
        $link = (string) $item->link[0];
        $description = (string) $item->description[0];
	$description = strip_tags($description);
	$pubDate = (string) $item->pubDate[0];
	$pubDateParsed = strtotime($pubDate);
	$pubDateObject = new DateTime($pubDateParsed);

        // See if this item is already in the database
        $countQuery = new ParseQuery("FeedStory");
	$countQuery->equalTo("guid", $guid);
	$count = $countQuery->count(); 
        if ($count == 0) {
        	// New item, so insert it
		echo "Inserting item\n";
        	echo "GUID: {$guid}\n";
        	echo "Title: {$title}\n";
        	echo "Link: {$link}\n";
        	echo "Description: {$description}\n";
        	echo "-------------------------\n";

                $feedStory = ParseObject::create("FeedStory");
                $feedStory->set("guid", $guid);
		$feedStory->set("title", $title);
		$feedStory->set("description", $description);
		$feedStory->set("url", $link);
		$feedStory->set("source", $source);
		$feedStory->set("publishDate", $pubDateObject);

		// Fetch the image using the utility class
		echo "Fetching image using utility class: {$utility_class}\n";
                $util = NULL;
		if ($utility_class == "vice") $util = new ViceUtilityClass();
		else if ($utility_class == "theguardian") $util = new TheGuardianUtilityClass();

		if ($util != NULL) {
			$file_data = $util->fetchImage($item);

			if ($file_data != NULL) {
				$image_file = ParseFile::createFromData($file_data, "story_image.jpg");
				$feedStory->set("image", $image_file);
				$feedStory->set("needsImage", FALSE);
			} else {
				$feedStory->set("needsImage", TRUE);
			}
		}

		$feedStory->save();
        } else echo "Skipping {$title}\n";;
       
	// sleep for 1 second so we don't flood Parse with requests
	sleep(1); 
    }
});
