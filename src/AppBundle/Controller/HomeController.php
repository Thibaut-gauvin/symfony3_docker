<?php

namespace AppBundle\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;

/**
 * Class HomeController
 * @package AppBundle\Controller
 */
class HomeController extends Controller
{
    /**
     * @Route("/", name="homepage")
     * @Method("GET")
     * @Template("AppBundle/Home/index.html.twig")
     */
    public function indexAction(Request $request)
    {
        return array(
            'name' => 'symfony'
        );
    }
}
