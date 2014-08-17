// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.tenminutes.web;

import com.tenminutes.Timer;
import com.tenminutes.web.TimerController;
import java.io.UnsupportedEncodingException;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect TimerController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String TimerController.create(@Valid Timer timer, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, timer);
            return "timers/create";
        }
        uiModel.asMap().clear();
        timer.persist();
        return "redirect:/timers/" + encodeUrlPathSegment(timer.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String TimerController.createForm(Model uiModel) {
        populateEditForm(uiModel, new Timer());
        return "timers/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String TimerController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("timer", Timer.findTimer(id));
        uiModel.addAttribute("itemId", id);
        return "timers/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String TimerController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "sortFieldName", required = false) String sortFieldName, @RequestParam(value = "sortOrder", required = false) String sortOrder, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("timers", Timer.findTimerEntries(firstResult, sizeNo, sortFieldName, sortOrder));
            float nrOfPages = (float) Timer.countTimers() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("timers", Timer.findAllTimers(sortFieldName, sortOrder));
        }
        return "timers/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String TimerController.update(@Valid Timer timer, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, timer);
            return "timers/update";
        }
        uiModel.asMap().clear();
        timer.merge();
        return "redirect:/timers/" + encodeUrlPathSegment(timer.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String TimerController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, Timer.findTimer(id));
        return "timers/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String TimerController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Timer timer = Timer.findTimer(id);
        timer.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/timers";
    }
    
    void TimerController.populateEditForm(Model uiModel, Timer timer) {
        uiModel.addAttribute("timer", timer);
    }
    
    String TimerController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        } catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}
