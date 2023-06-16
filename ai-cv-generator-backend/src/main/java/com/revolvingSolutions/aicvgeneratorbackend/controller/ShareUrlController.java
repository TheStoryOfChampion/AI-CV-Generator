package com.revolvingSolutions.aicvgeneratorbackend.controller;

import com.revolvingSolutions.aicvgeneratorbackend.request.file.RetrieveFileWithURL;
import com.revolvingSolutions.aicvgeneratorbackend.service.ShareService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@CrossOrigin(value="*")
@RequestMapping(path = "/share")
@RequiredArgsConstructor
public class ShareUrlController {

    private final ShareService service;
    @PostMapping(value="")
    public ResponseEntity<Resource> getSharedFile(
            @RequestBody RetrieveFileWithURL request
            ) {
        return service.RetriveUrl(request);
    }

    @GetMapping(value="{uuid}")
    public ResponseEntity<Resource> getSharedFileWithURL(
            @PathVariable("uuid")UUID uuid
            ) {
        return service.RetriveUrl(
                RetrieveFileWithURL.builder()
                        .uuid(uuid)
                        .build()
        );
    }
}
