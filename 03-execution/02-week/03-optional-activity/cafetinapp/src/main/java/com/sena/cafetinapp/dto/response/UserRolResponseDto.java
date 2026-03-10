package com.sena.cafetinapp.dto.response;

import com.fasterxml.jackson.annotation.JsonView;
import com.sena.cafetinapp.dto.view.JsonViews;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class UserRolResponseDto {

    @JsonView(JsonViews.Resumen.class)
    private Integer idUserRol;

    @JsonView(JsonViews.Resumen.class)
    private Integer userId;

    @JsonView(JsonViews.Resumen.class)
    private Integer rolId;
}
