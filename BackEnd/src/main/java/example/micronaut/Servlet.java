/*
package example.micronaut;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.sql.Date;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import example.micronaut.domain.USERS;

@WebServlet("/login")
class LoginServlet extends HttpServlet {

    public LoginServlet()
    {super();} //auto-generates constructor

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException
    {
        //save parameters
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        //error checking - make sure no fields are blanks
        if(email.isEmpty() || password.isEmpty()){
            //return error - fields cannot be blank
            resp.setStatus(400);
        }
        USERS thing = Application.userRepository.findByEmail(email).orElse(null);
        //if thing is null, email is not in the database
        if (thing == null)
        {
            //return bad input
            resp.setStatus(400);
        }
        //if thing's password is not equal to password user entered, pw incorrect
        else if(thing.getPASSWORD() != password){
            //return bad input
            resp.setStatus(400);
        }
        else{
            //set ok status
            resp.setStatus(200);
        }
    }
}

@WebServlet("/register")
class RegisterServlet extends HttpServlet
{
    public RegisterServlet() {super();}

    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        //save all parameters
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String firstname = req.getParameter("firstname");
        String lastname = req.getParameter("lastname");

        //error checking - make sure all fields filled in
        if(email.isEmpty() || password.isEmpty() || firstname.isEmpty() || lastname.isEmpty()){
            //return bad input
            resp.setStatus(400);
        }
        //check if email already exists
        USERS thing = Application.userRepository.findByEmail(email).orElse(null);
        if (thing != null)
        {
            //return bad input
            resp.setStatus(400);
        }

        //03-03-2021
        //create new user and insert in database
        USERS newUser = new USERS(0, email, password, firstname, lastname, Date.valueOf("01-01-2021"));
        Application.userRepository.saveAll(Arrays.asList(newUser));

        //check if successful

        //set response to ok
        resp.setStatus(200);
    }
}
 */