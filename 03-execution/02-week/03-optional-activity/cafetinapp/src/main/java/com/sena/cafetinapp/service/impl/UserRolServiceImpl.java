package com.sena.cafetinapp.service.impl;

import com.sena.cafetinapp.dto.request.UserRolRequestDto;
import com.sena.cafetinapp.dto.response.UserRolResponseDto;
import com.sena.cafetinapp.model.User;
import com.sena.cafetinapp.model.Rol;
import com.sena.cafetinapp.model.UserRol;
import com.sena.cafetinapp.repository.UserRepository;
import com.sena.cafetinapp.repository.RolRepository;
import com.sena.cafetinapp.repository.UserRolRepository;
import com.sena.cafetinapp.service.UserRolService;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserRolServiceImpl implements UserRolService {

    private final UserRolRepository repository;
    private final UserRepository userRepository;
    private final RolRepository rolRepository;

    @Override
    public UserRolResponseDto create(UserRolRequestDto request) {

        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Rol rol = rolRepository.findById(request.getRolId())
                .orElseThrow(() -> new RuntimeException("Rol no encontrado"));

        UserRol entity = new UserRol();
        entity.setUser(user);
        entity.setRol(rol);

        return mapToDto(repository.save(entity));
    }

    @Override
    public List<UserRolResponseDto> findAll() {
        return repository.findAll()
                .stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public UserRolResponseDto findById(Integer id) {
        UserRol entity = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Registro no encontrado"));
        return mapToDto(entity);
    }

    @Override
    public UserRolResponseDto update(Integer id, UserRolRequestDto request) {
        return create(request); // simple para este caso
    }

    @Override
    public void delete(Integer id) {
        repository.deleteById(id);
    }

    private UserRolResponseDto mapToDto(UserRol entity) {
        return UserRolResponseDto.builder()
                .idUserRol(entity.getIdUserRol())
                .userId(entity.getUser().getIdUser())
                .rolId(entity.getRol().getIdRol())
                .build();
    }
}