package com.revolvingSolutions.aicvgeneratorbackend.model.webscrapper;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class LinkedinResponseDTO {
    public String title;
    public String subTitle;
    public String subTitleLink;
    public String location;
}
