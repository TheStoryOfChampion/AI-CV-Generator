package com.revolvingSolutions.aicvgeneratorbackend.repository;

import com.revolvingSolutions.aicvgeneratorbackend.entitiy.ProfileImageEntity;
import com.revolvingSolutions.aicvgeneratorbackend.model.FileModelForList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ProfileImageRepository extends JpaRepository<ProfileImageEntity,Integer> {
    @Query("SELECT new com.revolvingSolutions.aicvgeneratorbackend.model.ProfileImageModel(f.imgdata) FROM ProfileImageEntity f WHERE f.user.username = ?1")
    public ProfileImageEntity getProfileImageFromUser(String username);
}
