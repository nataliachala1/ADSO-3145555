package com.sena.cafetinapp.service.impl;


import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import com.sena.cafetinapp.dto.request.UserRequestDto;
import com.sena.cafetinapp.dto.response.RolResponseDto;
import com.sena.cafetinapp.dto.response.UserResponseDto;
import com.sena.cafetinapp.model.Rol;
import com.sena.cafetinapp.model.User;
import com.sena.cafetinapp.repository.RolRepository;
import com.sena.cafetinapp.repository.UserRepository;
import com.sena.cafetinapp.service.UserService;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final RolRepository rolRepository;

    @Override
    public List<UserResponseDto> findAll() {
        return userRepository.findAll()
                .stream()
                .map(this::toResponseDto)
                .collect(Collectors.toList());
    }

    // =============================================
    // FIND BY ID
    // =============================================
    @Override
    public UserResponseDto findById(Integer id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado con id: " + id));
        return toResponseDto(user);
    }

    // =============================================
    // CREATE
    // =============================================
    @Override
    public UserResponseDto create(UserRequestDto dto) {
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new RuntimeException("Ya existe un usuario con el correo: " + dto.getEmail());
        }
        Rol rol = rolRepository.findById(dto.getIdRol())
                .orElseThrow(() -> new RuntimeException("Rol no encontrado con id: " + dto.getIdRol()));

        User user = User.builder()
                .name(dto.getName())
                .email(dto.getEmail())
                .password(dto.getPassword()) // ⚠️ En producción: encriptar con BCrypt
                .active(true)
                .rol(rol)
                .build();
        return toResponseDto(userRepository.save(user));
    }

    // =============================================
    // UPDATE
    // =============================================
    @Override
    public UserResponseDto update(Integer id, UserRequestDto dto) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado con id: " + id));
        Rol rol = rolRepository.findById(dto.getIdRol())
                .orElseThrow(() -> new RuntimeException("Rol no encontrado con id: " + dto.getIdRol()));

        user.setName(dto.getName());
        user.setEmail(dto.getEmail());
        user.setPassword(dto.getPassword()); // ⚠️ En producción: encriptar con BCrypt
        user.setRol(rol);
        return toResponseDto(userRepository.save(user));
    }

    // =============================================
    // DELETE
    // =============================================
    @Override
    public void delete(Integer id) {
        if (!userRepository.existsById(id)) {
            throw new RuntimeException("Usuario no encontrado con id: " + id);
        }
        userRepository.deleteById(id);
    }

    // =============================================
    // MAPPER — Entity → ResponseDto
    // =============================================
    private UserResponseDto toResponseDto(User user) {
        RolResponseDto rolDto = RolResponseDto.builder()
                .idRol(user.getRol().getIdRol())
                .name(user.getRol().getName())
                .description(user.getRol().getDescription())
                .build();

        return UserResponseDto.builder()
                .idUser(user.getIdUser())
                .name(user.getName())
                .email(user.getEmail())
                .active(user.getActive())
                .rol(rolDto)
                .build();
    }
}