// auth.guard.ts
import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, Router, UrlTree } from '@angular/router';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {

  constructor(private router: Router) {}

  canActivate(route: ActivatedRouteSnapshot): boolean | UrlTree {
    const token = typeof window !== 'undefined' ? localStorage.getItem('token') : null;
    const role = typeof window !== 'undefined' ? localStorage.getItem('role') : null;
    const path = route.routeConfig?.path;

    if (!token) return this.router.createUrlTree(['/login']);
    if (path === 'student-dashboard' && role !== 'student') return this.router.createUrlTree(['/forbidden']);
    if (path === 'school-dashboard' && role !== 'school') return this.router.createUrlTree(['/forbidden']);
    
    return true;
  }
}









// import { Injectable } from '@angular/core';



// import { CanActivateFn, ActivatedRouteSnapshot, Router, UrlTree } from '@angular/router';
// import { inject } from '@angular/core';

// @Injectable({ providedIn: 'root' })
// export class AuthGuard {
//   canActivate: CanActivateFn = (route: ActivatedRouteSnapshot): boolean | UrlTree => {
//     const router = inject(Router);
//     const token = localStorage.getItem('token');
//     const role = localStorage.getItem('role');
//     const path = route.routeConfig?.path;

//     if (!token) return router.createUrlTree(['/login']);
//     if (path === 'student-dashboard' && role !== 'student') return router.createUrlTree(['/forbidden']);
//     if (path === 'school-dashboard' && role !== 'school') return router.createUrlTree(['/forbidden']);
//     return true;
//   };
// }
