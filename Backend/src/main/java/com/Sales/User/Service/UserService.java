package com.Sales.User.Service;

import com.Sales.User.DTO.UserDTO;
import com.Sales.User.Model.User;
import com.Sales.User.Repo.UserRepo;
import jakarta.transaction.Transactional;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Transactional
public class UserService {
    @Autowired
    private UserRepo userRepo;

    @Autowired
    private ModelMapper modelMapper;

    public List<UserDTO> getAllUsers(){
        List<User>userList = userRepo.findAll();
        return modelMapper.map(userList, new TypeToken<List<UserDTO>>(){}.getType());
    }

    public UserDTO getUserById(int userId){
        User user = userRepo.getUserById(userId);
        return modelMapper.map(user, UserDTO.class);
    }

    public UserDTO saveUser(UserDTO userDTO){
        userRepo.save(modelMapper.map(userDTO, User.class));
        return userDTO;
    }

    public UserDTO updateUser(UserDTO userDTO){
        userRepo.save(modelMapper.map(userDTO, User.class));
        return userDTO;
    }

    public String deleteUser1(Integer userId){
        userRepo.deleteById(userId);
        return "User deleted1";
    }

    public String deleteUser2(UserDTO userDTO){
        userRepo.delete(modelMapper.map(userDTO, User.class));
        return "User deleted2";
    }
}
