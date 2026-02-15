package com.Sales.User.Controller;

import com.Sales.User.DTO.UserDTO;
import com.Sales.User.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin
@RequestMapping(value = "api/v3/")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("/getusers")
    public List<UserDTO> getUsers(){
        return userService.getAllUsers();
    }

    @GetMapping("/getuser/{userId}")
    public UserDTO getUserById(@PathVariable Integer userId){
        return userService.getUserById(userId);
    }

    @PostMapping("/adduser")
    public UserDTO addUser(@RequestBody UserDTO userDTO){
        return userService.saveUser(userDTO);
    }

    @PutMapping("/updateuser")
    public UserDTO updateUser(@RequestBody UserDTO userDTO){
        return userService.updateUser(userDTO);
    }

    @DeleteMapping("/deleteuser")
    public String deleteUser2(@RequestBody UserDTO userDTO){
        return userService.deleteUser2(userDTO);
    }

    @DeleteMapping("/deleteuser/{userId}")
    public String deleteUser1(@PathVariable Integer userId){
        return userService.deleteUser1(userId);
    }
}
