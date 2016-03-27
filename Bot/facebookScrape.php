<?php
	require_once 'facebook-php-sdk-v4/src/Facebook/autoload.php';
	if (isset(POST['id'])) {
		$fb = new Facebook\Facebook([
			'app_id' => '568834306623327',
			'app_secret' => 'bbe13aba86189f80598de8506ef2bee8',
			'default_graph_version' => 'v2.5',
		]);

		$request = new FacebookRequest(
		  $fb,
		  'GET',
		  POST['id']
		);
		$response = $request->execute();
		$graphObject = $response->getGraphObject();
	}
?>
