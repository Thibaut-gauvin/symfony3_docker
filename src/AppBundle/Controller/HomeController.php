<?php
/**
 * NOTICE OF LICENSE
 *
 * This source file is licensed exclusively to YOUR NAME
 * @note        Feel free to modify this template, take a look at .php_cs file
 *
 * @copyright   Copyright © 2017-2017 YOUR NAME
 * @license     All rights reserved
 * @author      YOUR NAME [name@email.domain]
 */

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

/**
 * Class HomeController.
 */
class HomeController extends Controller
{
    /**
     * Index action.
     *
     * @Route("/", name="homepage")
     * @Method("GET")
     * @Template("AppBundle/Home/index.html.twig")
     */
    public function indexAction(Request $request)
    {
        return [
            'name' => 'symfony',
        ];
    }
}
