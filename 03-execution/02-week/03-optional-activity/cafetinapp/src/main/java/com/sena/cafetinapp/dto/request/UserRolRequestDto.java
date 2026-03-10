package com.sena.cafetinapp.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserRolRequestDto {

    @NotNull(message = "El usuario es obligatorio")
    private Integer userId;

    @NotNull(message = "El rol es obligatorio")
    private Integer rolId;

}
