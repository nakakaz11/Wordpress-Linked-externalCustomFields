<?php
require_once './phplib/medoo.php';
//require "connect.php";
require "todo.class.php";

$id = (int)$_GET['id'];

try{

	switch($_GET['action'])
	{
		case 'delete':      // misc追加でもOK
			ToDo::delete($id);
			break;
			
		case 'rearrange':   // misc追加でもOK
			ToDo::rearrange($_GET['positions']);
			break;
			
		case 'edit':         // fix 1116
			ToDo::edit($id,$_GET['text'],$_GET['misc']);
			break;
			                   // fix OK
		case 'new':
			ToDo::createNew($_GET['text'],$_GET['misc']);
			break;
	}

}
catch(Exception $e){
	echo $e->getMessage();
	die("0");
}

echo "1";
?>